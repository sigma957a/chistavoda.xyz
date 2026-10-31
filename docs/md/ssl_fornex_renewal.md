# SSL на Fornex: `chistavoda.xyz` / `*.chistavoda.xyz`

## Инвентарь на VPS (окт 2026)

### Certbot

| Cert name | Domains | Path | Статус |
|-----------|---------|------|--------|
| `chistavoda.xyz` | `chistavoda.xyz`, `*.chistavoda.xyz` | `/etc/letsencrypt/live/chistavoda.xyz/` | **EXPIRED** (нужен DNS-01 renew) |
| `block.chistavoda.xyz` | `block.chistavoda.xyz` | `/etc/letsencrypt/live/block.chistavoda.xyz/` | VALID (временный HTTP-01, пока wildcard мёртв) |

### nginx `server_name` → `ssl_certificate`

| server_name | cert |
|-------------|------|
| `a.chistavoda.xyz` | LE wildcard `chistavoda.xyz` |
| `block.chistavoda.xyz` | LE `block.chistavoda.xyz` (отдельный) |
| `chistavoda.xyz` `www.chistavoda.xyz` | Hestia PEM **и** LE wildcard (оба) |
| `monitor.chistavoda.xyz` | LE wildcard |
| `osmo.chistavoda.xyz` | LE wildcard |
| `telegram-bot-support.chistavoda.xyz` | LE wildcard |
| `terminal.chistavoda.xyz` | LE wildcard |
| `webmail.chistavoda.xyz` `mail.chistavoda.xyz` | Hestia mail PEM (тоже wildcard SAN, **expired**) |
| `osmex.cz` `www.osmex.cz` | отдельный Hestia PEM (не Чиста вода) |
| `274884.fornex.cloud` | сертификат хоста Fornex |

DNS зоны Hestia **нет**; NS = `ns1–4.fornex.com`. Cloudflare для зоны не используется.

## Корневая причина wildcard

Renewal config:

- `authenticator = manual`
- `pref_challs = dns-01`
- раньше `manual_auth_hook = /tmp/auth_hook.sh` (**файл пропал** → `certbot renew` падал)

Без DNS API Fornex на сервере автопродление wildcard невозможно. Скрипты в `telegram-bot-support…/deploy/fornex_get_wildcard_cert.sh` — только **интерактивный** DNS-01.

## Как продлить wildcard (предпочтительный путь)

На VPS уже стоят durable hooks:

- auth: `/usr/local/bin/chistavoda-acme-auth-hook.sh`
- cleanup: `/usr/local/bin/chistavoda-acme-cleanup-hook.sh`
- state: `/var/lib/chistavoda-ops/acme-challenge.txt`
- сигнал: `chistavoda-acme-mark-ready.sh` → `touch /var/lib/chistavoda-ops/acme-ready`

```bash
sudo certbot renew --cert-name chistavoda.xyz --no-random-sleep-on-renew
# хук запишет TXT в /var/lib/chistavoda-ops/acme-challenge.txt и будет ждать
```

1. Панель Fornex → DNS `chistavoda.xyz` → TXT:
   - host: `_acme-challenge`
   - value: из `acme-challenge.txt` (поле `validation` / `value`)
2. Проверка: `dig +short TXT _acme-challenge.chistavoda.xyz @ns1.fornex.com`
3. `sudo chistavoda-acme-mark-ready.sh`
4. Certbot может запросить **второй** TXT (для `*.chistavoda.xyz`) — обновите/добавьте второе значение на том же имени, снова `mark-ready`.
5. `sudo nginx -t && sudo systemctl reload nginx`
6. Проверка:
   ```bash
   echo | openssl s_client -connect block.chistavoda.xyz:443 -servername block.chistavoda.xyz 2>/dev/null \
     | openssl x509 -noout -dates -ext subjectAltName
   ```

После успешного wildcard имеет смысл снова указать `block` на  
`/etc/letsencrypt/live/chistavoda.xyz/{fullchain,privkey}.pem` и удалить отдельный cert `block.chistavoda.xyz`, либо оставить как есть.

## Другие просроченные PEM (Hestia)

| Файл | notAfter | Примечание |
|------|----------|------------|
| `/home/admin/conf/web/chistavoda.xyz/ssl/chistavoda.xyz.pem` | 2026-02-11 | apex/www; `v-add-letsencrypt-domain` падает: ACME HTTP→HTTPS 404 |
| `/home/admin/conf/mail/chistavoda.xyz/ssl/chistavoda.xyz.pem` | 2026-06-22 | mail/webmail; после wildcard — скопировать LE fullchain/key сюда или включить LE в Hestia |

`osmex.cz` и `274884.fornex.cloud` валидны до ~2026-12-03 — не трогать без нужды.

## Чего нет на сервере

- Fornex DNS API token / certbot DNS plugin
- Hestia DNS zone для `chistavoda.xyz`
- Рабочий `/tmp/auth_hook.sh` (заменён на `/usr/local/bin/chistavoda-acme-*.sh`)
