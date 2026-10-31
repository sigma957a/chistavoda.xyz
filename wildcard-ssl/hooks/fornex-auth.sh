#!/usr/bin/env bash
# certbot manual-auth-hook: publish TXT _acme-challenge via Fornex DNS API.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=../lib/fornex-dns.sh
source "${ROOT}/lib/fornex-dns.sh"

DOMAIN="${DOMAIN:-chistavoda.xyz}"
STATE_DIR="${STATE_DIR:-/var/lib/wildcard-ssl}"
DNS_PROPAGATION_SECONDS="${DNS_PROPAGATION_SECONDS:-30}"
DNS_WAIT_MAX="${DNS_WAIT_MAX:-180}"

: "${CERTBOT_DOMAIN:?CERTBOT_DOMAIN not set}"
: "${CERTBOT_VALIDATION:?CERTBOT_VALIDATION not set}"

mkdir -p "$STATE_DIR"
chmod 700 "$STATE_DIR" 2>/dev/null || true

echo "AUTH: publishing TXT _acme-challenge.${DOMAIN} for CERTBOT_DOMAIN=${CERTBOT_DOMAIN}" >&2

id="$(fornex_add_acme_txt "$DOMAIN" "$CERTBOT_VALIDATION" "_acme-challenge")"
printf '%s\n' "$id" > "${STATE_DIR}/txt-id-${CERTBOT_VALIDATION}.id"
chmod 600 "${STATE_DIR}/txt-id-${CERTBOT_VALIDATION}.id" 2>/dev/null || true

# Wait until authoritative NS sees the value (best-effort).
deadline=$((SECONDS + DNS_WAIT_MAX))
found=0
while (( SECONDS < deadline )); do
  if dig +short TXT "_acme-challenge.${DOMAIN}" @"${FORNEX_NS:-ns1.fornex.com}" 2>/dev/null \
    | grep -Fq -- "$CERTBOT_VALIDATION"; then
    found=1
    break
  fi
  sleep 5
done

if [[ "$found" -ne 1 ]]; then
  echo "WARN: TXT not yet visible on ${FORNEX_NS:-ns1.fornex.com}; sleeping ${DNS_PROPAGATION_SECONDS}s more." >&2
  sleep "$DNS_PROPAGATION_SECONDS"
else
  # small settle
  sleep 5
fi

echo "AUTH: TXT published (id=${id})." >&2
exit 0
