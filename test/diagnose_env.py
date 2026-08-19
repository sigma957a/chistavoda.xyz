import os
from dotenv import load_dotenv


def diagnose_env_file():
    """Детальная диагностика файла .env"""
    print("🔍 ДИАГНОСТИКА ФАЙЛА .env")
    print("=" * 60)

    env_file_path = ".env"

    if not os.path.exists(env_file_path):
        print("❌ Файл .env не найден!")
        return

    # Читаем файл как байты и как текст
    print("📄 АНАЛИЗ СОДЕРЖИМОГО ФАЙЛА .env:")
    print("-" * 40)

    try:
        # Читаем файл построчно
        with open(env_file_path, "r", encoding="utf-8") as f:
            lines = f.readlines()

        print(f"📊 Всего строк в файле: {len(lines)}")
        print()

        for i, line in enumerate(lines, 1):
            line_repr = repr(line)  # Показывает скрытые символы
            print(f"Строка {i:2d}: {line_repr}")

            # Анализируем строку
            line_clean = line.strip()
            if line_clean and not line_clean.startswith("#"):
                if "=" in line_clean:
                    key, value = line_clean.split("=", 1)
                    key = key.strip()
                    value = value.strip()
                    print(f"         🔑 Ключ: '{key}' | 💎 Значение: '{value}'")
                else:
                    print(f"         ⚠️  Строка без '=' - возможная ошибка")
            elif line_clean.startswith("#"):
                print(f"         💬 Комментарий")
            else:
                print(f"         ⭕ Пустая строка")
            print()

    except Exception as e:
        print(f"❌ Ошибка чтения файла: {e}")
        return

    print("-" * 60)

    # Загружаем переменные и проверяем
    print("🔄 ЗАГРУЗКА И ПРОВЕРКА ПЕРЕМЕННЫХ:")
    print()

    load_dotenv()

    # Проверяем конкретные переменные
    test_vars = {
        "EMAIL_ENABLED": os.environ.get("EMAIL_ENABLED"),
        "SMTP_USERNAME": os.environ.get("SMTP_USERNAME"),
        "SMTP_PASSWORD": os.environ.get("SMTP_PASSWORD"),
    }

    for var_name, var_value in test_vars.items():
        if var_value:
            if "PASSWORD" in var_name:
                masked = (
                    var_value[:6] + "*" * (len(var_value) - 6)
                    if len(var_value) > 6
                    else "*" * len(var_value)
                )
                print(f"✅ {var_name}: '{masked}'")
            else:
                print(f"✅ {var_name}: '{var_value}'")
        else:
            print(f"❌ {var_name}: НЕ НАЙДЕНА")

    print("\n" + "-" * 60)

    # Проверяем все переменные окружения с префиксом
    print("🌍 ВСЕ ПЕРЕМЕННЫЕ ОКРУЖЕНИЯ (фильтр EMAIL/SMTP):")
    env_vars = {
        k: v
        for k, v in os.environ.items()
        if any(prefix in k for prefix in ["EMAIL", "SMTP", "TELEGRAM", "SUPABASE"])
    }

    if env_vars:
        for key, value in sorted(env_vars.items()):
            if "PASSWORD" in key or "TOKEN" in key or "KEY" in key:
                masked = (
                    value[:6] + "*" * (len(value) - 6)
                    if len(value) > 6
                    else "*" * len(value)
                )
                print(f"🔍 {key}: {masked}")
            else:
                print(f"🔍 {key}: {value}")
    else:
        print("❌ Переменные не найдены в окружении!")


def create_correct_env_file():
    """Создает правильный .env файл"""
    print("\n🛠️  СОЗДАНИЕ ПРАВИЛЬНОГО .env ФАЙЛА:")
    print("-" * 40)

    correct_content = """# Telegram Bot токен
TELEGRAM_BOT_TOKEN=7693528048:AAFSvfr1_ozZF0QwaMBtiblbfGGymykKd-Y

# Supabase настройки 
SUPABASE_URL=https://rmhlqeapawkzqqebbeud.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJtaGxxZWFwYXdrenFxZWJiZXVkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTA5NzI5MjEsImV4cCI6MjA2NjU0ODkyMX0.UpEv_8tQagLQQ_kMhKvzyRDfG7R1DO6dSPV-9PmH9UI

# Служба поддержки
EMERGENCY_PHONE=050-777-30-15

# Email уведомления
EMAIL_ENABLED=true
SMTP_SERVER=smtp.gmail.com
SMTP_PORT=587
SMTP_USERNAME=chistavoda.xyz@gmail.com
SMTP_PASSWORD=qkmjfexojairkfuv
"""

    response = input("🤔 Хотите пересоздать файл .env? (y/n): ").lower().strip()

    if response in ["y", "yes", "да"]:
        try:
            # Создаем бэкап старого файла
            if os.path.exists(".env"):
                backup_name = ".env.backup"
                counter = 1
                while os.path.exists(backup_name):
                    backup_name = f".env.backup.{counter}"
                    counter += 1

                os.rename(".env", backup_name)
                print(f"📦 Старый файл сохранен как: {backup_name}")

            # Создаем новый файл
            with open(".env", "w", encoding="utf-8") as f:
                f.write(correct_content)

            print("✅ Новый файл .env создан!")
            print("🔄 Запустите диагностику снова для проверки")

        except Exception as e:
            print(f"❌ Ошибка создания файла: {e}")
    else:
        print("⭕ Файл не изменен")


if __name__ == "__main__":
    diagnose_env_file()
    create_correct_env_file()
