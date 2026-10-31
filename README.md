# Chista Voda — Telegram Support Bot

Telegram-бот поддержки автоматов «Чиста вода».

## Источник

Перенесено из [`sigma957a/telegram-support-bot`](https://github.com/sigma957a/telegram-support-bot) — PR [#2 Refactor conversation flow](https://github.com/sigma957a/telegram-support-bot/pull/2).

- Ветка: `refactor-conversation-flow`
- Коммит: `a34d349`

## Ветки

| Ветка | Описание |
|-------|----------|
| `main` | Основная ветка (содержимое PR #2) |
| `refactor-conversation-flow` | Зеркало PR #2 |

## Запуск

```bash
python main.py
```

Скопируйте `env.template` → `.env` и заполните переменные окружения.

## Деплой

Production-версия (v8+) работает на Fornex: `telegram-bot-support.chistavoda.xyz` (ветка `fornex-refactoring-5` в исходном репозитории).

## SSL (Fornex)

Wildcard Let’s Encrypt для `chistavoda.xyz` / `*.chistavoda.xyz` (в т.ч. `block.chistavoda.xyz`) обслуживается на VPS Fornex, не в этом репо.  
Симптомы просрочки и шаги продления: [`docs/md/ssl_fornex_renewal.md`](docs/md/ssl_fornex_renewal.md).
