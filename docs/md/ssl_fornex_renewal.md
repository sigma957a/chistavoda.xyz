# SSL на Fornex: `chistavoda.xyz` / `block.chistavoda.xyz`

## Симптом (окт 2026)

Браузер не открывает `https://block.chistavoda.xyz` (ошибка сертификата / «нет SSL»).  
Фактически: сайт на nginx **жив**, HTTP отвечает `301 → https://…`, на 443 отдаётся **просроченный** Let’s Encrypt wildcard.

## Диагностика (проверено снаружи)

| Проверка | Результат |
|----------|-----------|
| DNS | NS Fornex (`ns1–4.fornex.com`), A-запись на VPS, Cloudflare **не** используется |
| HTTP `:80` | nginx, `301` на HTTPS |
| HTTPS `:443` | TLS 1.3 handshake OK, контент отдаётся (UI «Управление роутером») |
| Сертификат | CN=`chistavoda.xyz`, SAN=`*.chistavoda.xyz` + `chistavoda.xyz` |
| Срок | `notBefore=2026-07-05`, **`notAfter=2026-10-03`** → **expired** |
| Эмитент | Let’s Encrypt YE1 (ECDSA) |

Тот же просроченный wildcard ломает и apex, и другие поддомены на этом IP (в т.ч. `telegram-bot-support.chistavoda.xyz`).

В этом репозитории **нет** nginx/certbot/Caddy/Vercel-конфига для `block.*` — только Telegram-бот. Исправление TLS делается **на сервере Fornex**, не merge’ем кода приложения.

## Корневая причина

Автопродление Let’s Encrypt для wildcard (`*.chistavoda.xyz`) не сработало (или не было настроено). Wildcard требует **DNS-01**, не HTTP-01. После `2026-10-03` клиенты отвергают сертификат.

Сообщение пользователя «нет ключа/сертификата» обычно = ошибка TLS в UI; файлы на сервере, скорее всего, на месте, но **просрочены**.

## Что сделать на VPS (нужен SSH / панель Fornex)

1. Зайти на VPS Fornex, где крутится nginx для `chistavoda.xyz`.
2. Проверить текущие сертификаты:
   ```bash
   sudo certbot certificates
   # или пути вида:
   sudo ls -la /etc/letsencrypt/live/chistavoda.xyz/
   sudo nginx -T 2>/dev/null | grep -E 'ssl_certificate|server_name'
   ```
3. Продлить wildcard (DNS-01). Вариант A — если уже есть DNS-плагин / hook Fornex:
   ```bash
   sudo certbot renew --dry-run
   sudo certbot renew
   sudo nginx -t && sudo systemctl reload nginx
   ```
   Вариант B — вручную (если renew падает):
   ```bash
   sudo certbot certonly --manual --preferred-challenges dns \
     -d chistavoda.xyz -d '*.chistavoda.xyz' \
     --cert-name chistavoda.xyz
   ```
   Certbot покажет TXT `_acme-challenge.chistavoda.xyz` — добавить в DNS Fornex, дождаться распространения, подтвердить. Затем reload nginx.
4. Если SSL ведётся только через панель Fornex: SSL/Let’s Encrypt → renew / reissue для `chistavoda.xyz` + `*.chistavoda.xyz`, привязать к тому же vhost.
5. Проверка с любой машины:
   ```bash
   echo | openssl s_client -connect block.chistavoda.xyz:443 -servername block.chistavoda.xyz 2>/dev/null \
     | openssl x509 -noout -dates -ext subjectAltName
   curl -sI https://block.chistavoda.xyz/
   ```
   Ожидание: `notAfter` в будущем, `curl` без `SSL certificate problem`.

## Автопродление (чтобы не повторилось)

- Убедиться, что `certbot.timer` / cron активен: `systemctl status certbot.timer`.
- Для wildcard DNS-01 нужен рабочий DNS API / hook (Fornex DNS API или скрипт обновления TXT).
- После renew: `deploy-hook` → `nginx -t && systemctl reload nginx`.
- Алерт за ~14 дней до expiry (мониторинг или `certbot renew --dry-run` в CI/cron с уведомлением).

## Чего здесь нет

- Доступа к SSH, паролям, API-ключам DNS, панели Fornex из этого агента.
- Конфигов reverse-proxy в git для `block.chistavoda.xyz`.
- Cloudflare (зона на Fornex NS) — смена SSL mode в Cloudflare **не** поможет.

## Связанный деплой бота

Production-бот: `telegram-bot-support.chistavoda.xyz` на том же Fornex (см. `README.md`). После продления wildcard HTTPS для бота тоже должен снова валидироваться.
