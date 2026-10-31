#!/usr/bin/env bash
# Shared Fornex DNS helpers for ACME DNS-01.
# Requires: FORNEX_API (or FORNEX_API_TOKEN / FORNEX_API_KEY). Never echo secrets.

set -euo pipefail

FORNEX_API_BASE="${FORNEX_API_BASE:-https://fornex.com/api}"
# Survives command-substitution subshells used by callers.
FORNEX_HTTP_CODE_FILE="${FORNEX_HTTP_CODE_FILE:-${TMPDIR:-/tmp}/fornex-http-code.$$}"

fornex_resolve_token() {
  if [[ -n "${FORNEX_API:-}" ]]; then
    printf '%s' "$FORNEX_API"
    return 0
  fi
  if [[ -n "${FORNEX_API_TOKEN:-}" ]]; then
    printf '%s' "$FORNEX_API_TOKEN"
    return 0
  fi
  if [[ -n "${FORNEX_API_KEY:-}" ]]; then
    printf '%s' "$FORNEX_API_KEY"
    return 0
  fi
  return 1
}

fornex_auth_header() {
  local token
  token="$(fornex_resolve_token)" || {
    echo "ERROR: FORNEX_API is not set (also accept FORNEX_API_TOKEN / FORNEX_API_KEY)." >&2
    return 1
  }
  if [[ ${#token} -lt 8 ]]; then
    echo "ERROR: FORNEX_API looks empty/invalid (length check failed)." >&2
    return 1
  fi
  printf 'Authorization: Api-Key %s' "$token"
}

fornex_last_http_code() {
  if [[ -f "$FORNEX_HTTP_CODE_FILE" ]]; then
    tr -d '[:space:]' < "$FORNEX_HTTP_CODE_FILE"
  else
    printf 'n/a'
  fi
}

# fornex_api METHOD PATH [json_body]
# Prints response body on stdout. Writes HTTP code to FORNEX_HTTP_CODE_FILE.
fornex_api() {
  local method="$1"
  local path="$2"
  local body="${3:-}"
  local url="${FORNEX_API_BASE%/}/${path#/}"
  local auth
  auth="$(fornex_auth_header)" || return 1

  local tmp code
  tmp="$(mktemp)"
  if [[ -n "$body" ]]; then
    code="$(curl -sS -o "$tmp" -w '%{http_code}' \
      -X "$method" \
      -H "$auth" \
      -H 'Accept: application/json' \
      -H 'Content-Type: application/json' \
      --connect-timeout 15 \
      --max-time 60 \
      --data "$body" \
      "$url" || printf '000')"
  else
    code="$(curl -sS -o "$tmp" -w '%{http_code}' \
      -X "$method" \
      -H "$auth" \
      -H 'Accept: application/json' \
      --connect-timeout 15 \
      --max-time 60 \
      "$url" || printf '000')"
  fi
  printf '%s' "$code" > "$FORNEX_HTTP_CODE_FILE"
  cat "$tmp"
  rm -f "$tmp"
  [[ "$code" =~ ^2 ]]
}

fornex_check_api() {
  local domain="${1:?domain required}"
  local out code
  set +e
  out="$(fornex_api GET "dns/domain/${domain}/entry_set/?type=TXT")"
  local rc=$?
  set -e
  code="$(fornex_last_http_code)"
  if [[ "$rc" -ne 0 ]]; then
    echo "ERROR: Fornex DNS API unavailable or unauthorized (HTTP ${code})." >&2
    echo "ERROR: Check FORNEX_API token and network; secret value is not shown." >&2
    return 1
  fi
  echo "OK: Fornex DNS API reachable for ${domain} (HTTP ${code})."
}

# Create TXT host=_acme-challenge (relative), print record id.
fornex_add_acme_txt() {
  local domain="${1:?}"
  local value="${2:?}"
  local host="${3:-_acme-challenge}"
  local payload out id
  payload="$(printf '{"host":"%s","type":"TXT","value":"%s","ttl":null}' "$host" "$value")"
  set +e
  out="$(fornex_api POST "dns/domain/${domain}/entry_set/" "$payload")"
  local rc=$?
  set -e
  if [[ "$rc" -ne 0 ]]; then
    echo "ERROR: failed to create TXT ${host}.${domain} (HTTP $(fornex_last_http_code))." >&2
    return 1
  fi
  id="$(printf '%s' "$out" | python3 -c 'import sys,json; print(json.load(sys.stdin).get("id",""))' 2>/dev/null || true)"
  if [[ -z "$id" ]]; then
    echo "ERROR: Fornex create TXT returned no id." >&2
    return 1
  fi
  printf '%s\n' "$id"
}

fornex_delete_entry() {
  local domain="${1:?}"
  local id="${2:?}"
  set +e
  fornex_api DELETE "dns/domain/${domain}/entry_set/${id}/" >/dev/null
  local rc=$?
  set -e
  if [[ "$rc" -ne 0 ]]; then
    echo "WARN: failed to delete DNS entry id=${id} (HTTP $(fornex_last_http_code))." >&2
    return 1
  fi
}

# Delete TXT records for host matching value (best-effort).
fornex_delete_acme_txt_by_value() {
  local domain="${1:?}"
  local value="${2:?}"
  local host="${3:-_acme-challenge}"
  local out ids
  set +e
  out="$(fornex_api GET "dns/domain/${domain}/entry_set/?type=TXT")"
  local rc=$?
  set -e
  [[ "$rc" -eq 0 ]] || return 1
  ids="$(printf '%s' "$out" | HOST="$host" VAL="$value" python3 - <<'PY'
import json, os, sys
host = os.environ["HOST"]
val = os.environ["VAL"]
data = json.load(sys.stdin)
for e in data:
    h = (e.get("host") or "").rstrip(".")
    if h in (host, f"{host}."):
        if (e.get("value") or "").strip('"') == val.strip('"'):
            print(e["id"])
PY
)"
  local id
  for id in $ids; do
    fornex_delete_entry "$domain" "$id" || true
  done
}
