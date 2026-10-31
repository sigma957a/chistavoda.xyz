# wildcard.chistavoda.xyz

Одна команда для продления Let’s Encrypt **wildcard** SSL: `chistavoda.xyz` + `*.chistavoda.xyz` через **Fornex DNS-01**.

На проде VPS сертификат уже один раз продлили вручную с `FORNEX_API`. Этот репозиторий делает тот же процесс **повторяемым**.

## Что покрывает

Один сертификат с SAN:

- `chistavoda.xyz`
- `*.chistavoda.xyz`

Все поддомены (`block`, `a`, `monitor`, `osmo`, `terminal`, `telegram-bot-support`, `www`, `mail`, …) используют этот wildcard (если сайт не на отдельном cert).

## Требования

- root на VPS (Hestia / nginx)
- `certbot`, `curl`, `python3`, `openssl`, `dig`
- секрет **`FORNEX_API`** — API-ключ Fornex с правом DNS зоны `chistavoda.xyz`  
  (альтернативные имена: `FORNEX_API_TOKEN`, `FORNEX_API_KEY`)

Секреты **не** коммитить и **не** печатать в логах.

## Установка

```bash
git clone https://github.com/sigma957a/wildcard.chistavoda.xyz.git
cd wildcard.chistavoda.xyz
chmod +x renew-wildcard.sh hooks/*.sh
# опционально:
sudo make install-hooks   # → /usr/local/sbin/renew-wildcard
```

Зависимости (Debian/Ubuntu):

```bash
sudo apt-get update
sudo apt-get install -y certbot curl python3 openssl dnsutils
```

## Секреты / env

| Переменная | Обязательно | Описание |
|------------|-------------|----------|
| `FORNEX_API` | да | токен Fornex (`Authorization: Api-Key …`) |
| `DOMAIN` | нет | по умолчанию `chistavoda.xyz` |
| `EMAIL` | нет | email для Let’s Encrypt |
| `RENEW_DAYS` | нет | окно продления, по умолчанию `30` |
| `FORCE` | нет | `1` — продлить даже если дней хватает |
| `CHECK_ONLY` | нет | `1` — только preflight, без certbot |
| `SYNC_HESTIA` | нет | `1` (default) — синхронизация PEM в Hestia |
| `RELOAD_NGINX` | нет | `1` (default) — `nginx -t` + reload |

Пример без записи в историю shell:

```bash
read -s FORNEX_API && export FORNEX_API
```

Или файл `/root/.config/wildcard-ssl.env` (права `600`):

```bash
export FORNEX_API='…'
# export EMAIL='ops@example.com'
```

## Одна команда

```bash
cd /path/to/wildcard.chistavoda.xyz
sudo -E ./renew-wildcard.sh
# или:
sudo -E make renew
```

Скрипт сам:

1. **Preflight Fornex API** — `GET …/dns/domain/$DOMAIN/entry_set/`; при ошибке/401 — явный fail, без дампа секрета.
2. **Проверка текущего cert** — `notBefore` / `notAfter` / SANs; если валиден и осталось **> 30 дней** — пишет статус и **не** дергает Let’s Encrypt.
3. При необходимости — **certbot DNS-01**: ставит/чистит TXT `_acme-challenge` через Fornex API.
4. Синхронизирует Hestia PEM (если каталоги есть) и **reload nginx**.

Принудительно:

```bash
sudo -E FORCE=1 ./renew-wildcard.sh
```

Только проверка:

```bash
sudo -E CHECK_ONLY=1 ./renew-wildcard.sh
# exit 0 — renew не нужен; exit 10 — renew потребовался бы
```

## Автопродление

### systemd timer

```bash
sudo cp systemd/wildcard-renew.service systemd/wildcard-renew.timer /etc/systemd/system/
# положите FORNEX_API в EnvironmentFile (см. unit)
sudo systemctl daemon-reload
sudo systemctl enable --now wildcard-renew.timer
```

### cron

См. `cron.example`:

```cron
15 4 * * * root . /root/.config/wildcard-ssl.env; /usr/local/sbin/renew-wildcard >>/var/log/wildcard-ssl-renew.log 2>&1
```

## API Fornex (как на проде)

- Base: `https://fornex.com/api`
- Auth: `Authorization: Api-Key $FORNEX_API`
- TXT ACME: `POST /dns/domain/chistavoda.xyz/entry_set/` с `host=_acme-challenge`, `type=TXT`
- Удаление: `DELETE /dns/domain/chistavoda.xyz/entry_set/{id}/`

## Безопасность

- скрипт не выводит значение `FORNEX_API`
- state ACME id: `/var/lib/wildcard-ssl` (mode `700`)
- перед правкой Hestia PEM — бэкап в `/root/ssl-backup-<UTC>/`
