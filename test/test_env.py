import os
from dotenv import load_dotenv

def test_env_loading():
    """Тест загрузки переменных окружения из .env файла"""
    print("🧪 ТЕСТ ЗАГРУЗКИ ПЕРЕМЕННЫХ ОКРУЖЕНИЯ")
    print("=" * 60)
    
    # Проверяем существование .env файла
    env_file_path = ".env"
    if os.path.exists(env_file_path):
        print(f"✅ Файл {env_file_path} найден")
        
        # Читаем содержимое файла
        try:
            with open(env_file_path, 'r', encoding='utf-8') as f:
                content = f.read()
                lines = [line.strip() for line in content.split('\n') if line.strip() and not line.startswith('#')]
                print(f"📄 В файле .env найдено {len(lines)} строк с переменными")
        except Exception as e:
            print(f"❌ Ошибка чтения файла .env: {e}")
            return False
    else:
        print(f"❌ Файл {env_file_path} НЕ НАЙДЕН!")
        print("🔧 Убедитесь, что файл .env находится в той же папке, что и скрипт")
        return False
    
    print("\n" + "-" * 60)
    
    # Загружаем переменные из .env
    print("🔄 Загрузка переменных из .env...")
    load_dotenv()
    print("✅ load_dotenv() выполнен")
    
    print("\n" + "-" * 60)
    
    # Список переменных для проверки
    required_vars = [
        "TELEGRAM_BOT_TOKEN",
        "SUPABASE_URL", 
        "SUPABASE_ANON_KEY",
        "EMERGENCY_PHONE",
        "EMAIL_ENABLED",
        "SMTP_SERVER",
        "SMTP_PORT", 
        "SMTP_USERNAME",
        "SMTP_PASSWORD"
    ]
    
    print("📋 ПРОВЕРКА ПЕРЕМЕННЫХ ОКРУЖЕНИЯ:")
    print()
    
    all_loaded = True
    
    for var_name in required_vars:
        value = os.environ.get(var_name)
        
        if value:
            # Маскируем чувствительные данные
            if "TOKEN" in var_name or "PASSWORD" in var_name or "KEY" in var_name:
                if len(value) > 10:
                    masked_value = value[:6] + "*" * (len(value) - 10) + value[-4:]
                else:
                    masked_value = "*" * len(value)
                print(f"✅ {var_name:<20} = {masked_value}")
            else:
                print(f"✅ {var_name:<20} = {value}")
        else:
            print(f"❌ {var_name:<20} = НЕ УСТАНОВЛЕНА")
            all_loaded = False
    
    print("\n" + "-" * 60)
    
    if all_loaded:
        print("🎉 ВСЕ ПЕРЕМЕННЫЕ ЗАГРУЖЕНЫ УСПЕШНО!")
        
        # Дополнительная проверка важных настроек
        print("\n📊 АНАЛИЗ НАСТРОЕК:")
        
        email_enabled = os.environ.get("EMAIL_ENABLED", "false").lower() == "true"
        smtp_user = os.environ.get("SMTP_USERNAME")
        smtp_pass = os.environ.get("SMTP_PASSWORD")
        
        print(f"📧 Email уведомления: {'✅ ВКЛЮЧЕНЫ' if email_enabled else '❌ ОТКЛЮЧЕНЫ'}")
        print(f"📧 SMTP пользователь: {'✅ НАСТРОЕН' if smtp_user else '❌ НЕ НАСТРОЕН'}")
        print(f"📧 SMTP пароль: {'✅ НАСТРОЕН' if smtp_pass else '❌ НЕ НАСТРОЕН'}")
        
        if email_enabled and smtp_user and smtp_pass:
            print("🎯 Email настройки выглядят корректно!")
        elif email_enabled and (not smtp_user or not smtp_pass):
            print("⚠️  Email включен, но SMTP настройки неполные!")
        
        return True
    else:
        print("❌ НЕКОТОРЫЕ ПЕРЕМЕННЫЕ НЕ ЗАГРУЖЕНЫ!")
        print("🔧 Проверьте содержимое файла .env")
        return False

def show_current_directory():
    """Показываем текущую рабочую директорию"""
    current_dir = os.getcwd()
    print(f"\n📁 Текущая рабочая директория: {current_dir}")
    
    # Показываем файлы в текущей директории
    try:
        files = os.listdir(current_dir)
        env_files = [f for f in files if f.startswith('.env')]
        py_files = [f for f in files if f.endswith('.py')]
        
        print(f"📋 Python файлы в директории: {', '.join(py_files) if py_files else 'НЕТ'}")
        print(f"🔧 .env файлы в директории: {', '.join(env_files) if env_files else 'НЕТ'}")
        
        if '.env' not in files:
            print("❌ ФАЙЛ .env НЕ НАЙДЕН В ТЕКУЩЕЙ ДИРЕКТОРИИ!")
            print("🔧 Убедитесь, что:")
            print("   • Файл .env существует")
            print("   • Файл .env находится в той же папке, что и Python скрипт")
            print("   • Имя файла точно '.env' (без расширения)")
    
    except Exception as e:
        print(f"❌ Ошибка чтения директории: {e}")

if __name__ == "__main__":
    show_current_directory()
    print()
    test_env_loading()
