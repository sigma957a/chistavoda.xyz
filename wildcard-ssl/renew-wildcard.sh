#!/usr/bin/env bash
# One-command renew/extend Let's Encrypt wildcard for DOMAIN + *.DOMAIN via Fornex DNS-01.
#
# Usage:
#   export FORNEX_API=...          # required (never commit)
#   ./renew-wildcard.sh            # preflight → renew only if needed
#   FORCE=1 ./renew-wildcard.sh    # renew even if > RENEW_DAYS left
#   CHECK_ONLY=1 ./renew-wildcard.sh
#
# Env:
#   DOMAIN=chistavoda.xyz
#   FORNEX_API | FORNEX_API_TOKEN | FORNEX_API_KEY
#   EMAIL=...                      # optional (certbot register / notifications)
#   RENEW_DAYS=30                  # skip renew if more days left (unless FORCE=1)
#   LIVE_PATH=/etc/letsencrypt/live/$DOMAIN
#   SYNC_HESTIA=1                  # sync Hestia PEM copies after success (default 1)
#   RELOAD_NGINX=1                 # nginx -t && reload (default 1)

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/fornex-dns.sh
source "${ROOT}/lib/fornex-dns.sh"

DOMAIN="${DOMAIN:-chistavoda.xyz}"
EMAIL="${EMAIL:-}"
RENEW_DAYS="${RENEW_DAYS:-30}"
FORCE="${FORCE:-0}"
CHECK_ONLY="${CHECK_ONLY:-0}"
LIVE_PATH="${LIVE_PATH:-/etc/letsencrypt/live/${DOMAIN}}"
CERT_NAME="${CERT_NAME:-$DOMAIN}"
STATE_DIR="${STATE_DIR:-/var/lib/wildcard-ssl}"
RELOAD_NGINX="${RELOAD_NGINX:-1}"
SYNC_HESTIA="${SYNC_HESTIA:-1}"
ACME_SERVER="${ACME_SERVER:-https://acme-v02.api.letsencrypt.org/directory}"

AUTH_HOOK="${ROOT}/hooks/fornex-auth.sh"
CLEANUP_HOOK="${ROOT}/hooks/fornex-cleanup.sh"

log() { printf '%s\n' "$*"; }
die() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || die "required command not found: $1"
}

preflight_deps() {
  need_cmd curl
  need_cmd python3
  need_cmd openssl
  need_cmd dig
  need_cmd certbot
}

preflight_api() {
  log "==> Preflight: Fornex DNS API"
  fornex_check_api "$DOMAIN" || exit 2
}

# Print cert status; return 0 if renew needed, 1 if skip (still valid).
cert_status() {
  local pem="${LIVE_PATH}/fullchain.pem"
  log "==> Preflight: current certificate (${pem})"

  if [[ ! -f "$pem" ]]; then
    log "STATUS: no certificate at ${pem} — renew/issue required."
    return 0
  fi

  local not_after not_before sans days_left end_epoch now_epoch
  not_after="$(openssl x509 -in "$pem" -noout -enddate | cut -d= -f2-)"
  not_before="$(openssl x509 -in "$pem" -noout -startdate | cut -d= -f2-)"
  sans="$(openssl x509 -in "$pem" -noout -ext subjectAltName 2>/dev/null | tr -d '\n' | sed 's/.*: //;s/DNS://g' || true)"
  if [[ -z "$sans" ]]; then
    sans="$(openssl x509 -in "$pem" -noout -text 2>/dev/null | awk '/Subject Alternative Name/{getline; print}' | tr -d ' ' | sed 's/DNS://g' || true)"
  fi

  end_epoch="$(date -d "$not_after" +%s 2>/dev/null || date -j -f '%b %d %T %Y %Z' "$not_after" +%s 2>/dev/null || echo 0)"
  now_epoch="$(date +%s)"
  if [[ "$end_epoch" -eq 0 ]]; then
    die "cannot parse certificate notAfter: ${not_after}"
  fi
  days_left=$(( (end_epoch - now_epoch) / 86400 ))

  log "STATUS: notBefore=${not_before}"
  log "STATUS: notAfter=${not_after}"
  log "STATUS: days_left=${days_left}"
  log "STATUS: SANs=${sans}"

  local has_apex=0 has_wild=0
  if printf '%s' "$sans" | tr ',' '\n' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' \
      | grep -Fxq -- "$DOMAIN"; then
    has_apex=1
  fi
  if printf '%s' "$sans" | tr ',' '\n' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' \
      | grep -Fxq -- "*.${DOMAIN}"; then
    has_wild=1
  fi

  if [[ "$has_apex" -ne 1 || "$has_wild" -ne 1 ]]; then
    log "STATUS: missing expected SANs (${DOMAIN} and *.${DOMAIN}) — renew required."
    return 0
  fi


  if [[ "$days_left" -lt 0 ]]; then
    log "STATUS: certificate EXPIRED — renew required."
    return 0
  fi

  if [[ "$FORCE" == "1" ]]; then
    log "STATUS: FORCE=1 — renewing despite ${days_left} days left."
    return 0
  fi

  if [[ "$days_left" -gt "$RENEW_DAYS" ]]; then
    log "STATUS: valid > ${RENEW_DAYS} days — skip renew (set FORCE=1 to renew anyway)."
    return 1
  fi

  log "STATUS: within renew window (≤ ${RENEW_DAYS} days) — renew required."
  return 0
}

reload_nginx() {
  [[ "$RELOAD_NGINX" == "1" ]] || return 0
  if ! command -v nginx >/dev/null 2>&1; then
    log "NOTE: nginx not found; skip reload."
    return 0
  fi
  if nginx -t; then
    if command -v systemctl >/dev/null 2>&1; then
      systemctl reload nginx
    else
      nginx -s reload
    fi
    log "OK: nginx reloaded."
  else
    die "nginx -t failed; not reloading."
  fi
}

sync_hestia_pems() {
  [[ "$SYNC_HESTIA" == "1" ]] || return 0
  local web_ssl="/home/admin/conf/web/${DOMAIN}/ssl"
  local mail_ssl="/home/admin/conf/mail/${DOMAIN}/ssl"
  local live="${LIVE_PATH}"

  if [[ ! -d "$web_ssl" && ! -d "$mail_ssl" ]]; then
    log "NOTE: Hestia SSL dirs not present — skip PEM sync (OK on non-Hestia hosts)."
    return 0
  fi

  local backup="/root/ssl-backup-$(date -u +%Y%m%dT%H%M%SZ)"
  mkdir -p "$backup"
  [[ -d "$web_ssl" ]] && cp -a "$web_ssl" "$backup/web-ssl" || true
  [[ -d "$mail_ssl" ]] && cp -a "$mail_ssl" "$backup/mail-ssl" || true
  log "OK: Hestia PEM backup → ${backup}"

  if [[ -d "$web_ssl" ]]; then
    install -m 644 "${live}/fullchain.pem" "${web_ssl}/${DOMAIN}.crt"
    install -m 644 "${live}/fullchain.pem" "${web_ssl}/${DOMAIN}.pem"
    install -m 600 "${live}/privkey.pem" "${web_ssl}/${DOMAIN}.key"
    # CA/chain if present
    if [[ -f "${live}/chain.pem" ]]; then
      install -m 644 "${live}/chain.pem" "${web_ssl}/${DOMAIN}.ca"
    fi
    log "OK: synced Hestia web SSL → ${web_ssl}"
  fi

  if [[ -d "$mail_ssl" ]]; then
    install -m 644 "${live}/fullchain.pem" "${mail_ssl}/${DOMAIN}.crt" 2>/dev/null \
      || install -m 644 "${live}/fullchain.pem" "${mail_ssl}/fullchain.pem"
    install -m 600 "${live}/privkey.pem" "${mail_ssl}/${DOMAIN}.key" 2>/dev/null \
      || install -m 600 "${live}/privkey.pem" "${mail_ssl}/privkey.pem"
    log "OK: synced Hestia mail SSL → ${mail_ssl}"
  fi
}

run_certbot() {
  export DOMAIN STATE_DIR FORNEX_API FORNEX_API_TOKEN FORNEX_API_KEY FORNEX_API_BASE
  mkdir -p "$STATE_DIR"
  chmod 700 "$STATE_DIR" 2>/dev/null || true

  local email_args=()
  if [[ -n "$EMAIL" ]]; then
    email_args=(--email "$EMAIL" --no-eff-email)
  else
    email_args=(--register-unsafely-without-email)
  fi

  local force_args=()
  if [[ "$FORCE" == "1" ]]; then
    force_args=(--force-renewal)
  fi

  log "==> Running certbot (DNS-01 via Fornex hooks)"
  # Prefer renew when lineage exists; otherwise certonly.
  if [[ -f "/etc/letsencrypt/renewal/${CERT_NAME}.conf" ]]; then
    certbot renew \
      --cert-name "$CERT_NAME" \
      --manual \
      --preferred-challenges dns \
      --manual-auth-hook "$AUTH_HOOK" \
      --manual-cleanup-hook "$CLEANUP_HOOK" \
      --manual-public-ip-logging-ok \
      --agree-tos \
      --no-random-sleep-on-renew \
      --server "$ACME_SERVER" \
      "${email_args[@]}" \
      "${force_args[@]}"
  else
    certbot certonly \
      --manual \
      --preferred-challenges dns \
      --manual-auth-hook "$AUTH_HOOK" \
      --manual-cleanup-hook "$CLEANUP_HOOK" \
      --manual-public-ip-logging-ok \
      --agree-tos \
      --cert-name "$CERT_NAME" \
      -d "$DOMAIN" \
      -d "*.${DOMAIN}" \
      --server "$ACME_SERVER" \
      "${email_args[@]}"
  fi
}

main() {
  if [[ "$(id -u)" -ne 0 ]]; then
    die "run as root (sudo). Example: sudo -E ./renew-wildcard.sh"
  fi

  preflight_deps
  preflight_api

  local need_renew=0
  if cert_status; then
    need_renew=1
  fi

  if [[ "$CHECK_ONLY" == "1" ]]; then
    if [[ "$need_renew" -eq 1 ]]; then
      log "CHECK_ONLY: renew would run."
      exit 10
    fi
    log "CHECK_ONLY: renew not needed."
    exit 0
  fi

  if [[ "$need_renew" -ne 1 ]]; then
    log "Done: nothing to renew."
    exit 0
  fi

  run_certbot
  sync_hestia_pems
  reload_nginx

  log "==> Post-check"
  cert_status || true
  log "Done: wildcard ${DOMAIN} + *.${DOMAIN} renewed/extended."
}

main "$@"
