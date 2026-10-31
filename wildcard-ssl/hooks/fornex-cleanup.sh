#!/usr/bin/env bash
# certbot manual-cleanup-hook: remove TXT _acme-challenge created by fornex-auth.sh.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=../lib/fornex-dns.sh
source "${ROOT}/lib/fornex-dns.sh"

DOMAIN="${DOMAIN:-chistavoda.xyz}"
STATE_DIR="${STATE_DIR:-/var/lib/wildcard-ssl}"

if [[ -z "${CERTBOT_VALIDATION:-}" ]]; then
  echo "CLEANUP: no CERTBOT_VALIDATION; nothing to do." >&2
  exit 0
fi

id_file="${STATE_DIR}/txt-id-${CERTBOT_VALIDATION}.id"
if [[ -f "$id_file" ]]; then
  id="$(tr -d '[:space:]' < "$id_file")"
  if [[ -n "$id" ]]; then
    fornex_delete_entry "$DOMAIN" "$id" || true
  fi
  rm -f "$id_file"
else
  fornex_delete_acme_txt_by_value "$DOMAIN" "$CERTBOT_VALIDATION" "_acme-challenge" || true
fi

echo "CLEANUP: removed ACME TXT for this challenge (if present)." >&2
exit 0
