import smtplib
import getpass
from email.mime.text import MIMEText

def test_gmail_connection():
    """Интерактивный тест подключения к Gmail с разными паролями"""
    print("🕵️ ДИАГНОСТИКА GMAIL ПОДКЛЮЧЕНИЯ")
    print("=" * 50)
    
    # Получаем учетные данные
    username = input("📧 Gmail адрес [chistavoda.xyz@gmail.com]: ").strip()
    if not username:
        username = "chistavoda.xyz@gmail.com"
    
    print("\n🔐 Варианты тестирования:")
    print("1. Использовать пароль из .env файла")
    print("2. Ввести новый пароль приложения")
    print("3. Проверить с основным паролем Gmail (не рекомендуется)")
    
    choice = input("\nВыберите вариант (1-3): ").strip()
    
    password = None
    
    if choice == "1":
        # Загружаем из .env
        from dotenv import load_dotenv
        import os
        load_dotenv()
        password = os.environ.get("SMTP_PASSWORD")
        if password:
            print(f"📄 Пароль из .env: {password[:6]}***")
        else:
            print("❌ Пароль не найден в .env файле!")
            return
    
    elif choice == "2":
        print("\n📝 Введите пароль приложения Gmail:")
        print("   (16 символов без пробелов, например: abcdwfghijk1mn2p)")
        password = getpass.getpass("🔑 Пароль приложения: ")
    
    elif choice == "3":
        print("\n⚠️  ВНИМАНИЕ: Основной пароль Gmail обычно не работает для SMTP!")
        password = getpass.getpass("🔑 Основной пароль Gmail: ")
    
    else:
        print("❌ Неверный выбор!")
        return
    
    if not password:
        print("❌ Пароль не введен!")
        return
    
    # Тестируем подключение
    print(f"\n🔄 Тестирование подключения...")
    print(f"📧 Email: {username}")
    print(f"🔑 Пароль: {password[:4]}{'*' * (len(password) - 4)}")
    print(f"🌐 Сервер: smtp.gmail.com:587")
    
    try:
        print("\n🔌 Подключение к SMTP серверу...")
        server = smtplib.SMTP("smtp.gmail.com", 587)
        server.set_debuglevel(1)  # Показываем детали SMTP
        
        print("\n🔒 Установка TLS соединения...")
        server.starttls()
        
        print("\n🔐 Авторизация...")
        server.login(username, password)
        
        print("\n✅ УСПЕХ! Авторизация прошла успешно!")
        
        # Предлагаем отправить тестовое письмо
        send_test = input("\n📤 Отправить тестовое письмо? (y/n): ").lower().strip()
        
        if send_test in ['y', 'yes', 'да']:
            to_email = input("📧 Email получателя: ").strip()
            if to_email:
                try:
                    msg = MIMEText("✅ Тест Gmail SMTP успешен! Настройки работают корректно.")
                    msg["Subject"] = "🧪 Тест ChistaVoda Gmail SMTP"
                    msg["From"] = username
                    msg["To"] = to_email
                    
                    server.send_message(msg)
                    print(f"📧 Тестовое письмо отправлено на {to_email}")
                except Exception as e:
                    print(f"❌ Ошибка отправки: {e}")
        
        server.quit()
        
        # Если все успешно, предлагаем обновить .env
        if choice == "2":
            update_env = input("\n💾 Обновить .env файл с этим паролем? (y/n): ").lower().strip()
            if update_env in ['y', 'yes', 'да']:
                update_env_file(password)
        
        print("\n🎉 Диагностика завершена успешно!")
        print("🔧 Рекомендации:")
        print("   • Используйте именно этот пароль в боте")
        print("   • Убедитесь, что EMAIL_ENABLED=true")
        print("   • Проверьте, что email владельца добавлен в базу")
        
        return True
        
    except smtplib.SMTPAuthenticationError as e:
        print(f"\n❌ ОШИБКА АВТОРИЗАЦИИ: {e}")
        
        if choice == "1":
            print("\n🔧 Пароль из .env файла неверный!")
            print("   Создайте новый пароль приложения Gmail")
        elif choice == "2":
            print("\n🔧 Проверьте пароль приложения:")
            print("   • Убедитесь, что это пароль приложения (не основной)")
            print("   • Пароль должен быть 16 символов без пробелов")
            print("   • Создайте новый пароль если этот старый")
        else:
            print("\n🔧 Основной пароль Gmail не работает для SMTP!")
            print("   Создайте пароль приложения:")
            print("   1. Google Account → Security → App passwords")
            print("   2. Выберите Mail → Other → ChistaVoda")
            print("   3. Используйте сгенерированный пароль")
        
        return False
        
    except Exception as e:
        print(f"\n❌ ОБЩАЯ ОШИБКА: {e}")
        return False

def update_env_file(new_password):
    """Обновляет пароль в .env файле"""
    try:
        # Читаем текущий файл
        with open('.env', 'r', encoding='utf-8') as f:
            lines = f.readlines()
        
        # Обновляем строку с паролем
        updated = False
        for i, line in enumerate(lines):
            if line.startswith('SMTP_PASSWORD='):
                lines[i] = f'SMTP_PASSWORD={new_password}\n'
                updated = True
                break
        
        if updated:
            # Записываем обновленный файл
            with open('.env', 'w', encoding='utf-8') as f:
                f.writelines(lines)
            print("✅ Файл .env обновлен с новым паролем!")
        else:
            print("⚠️ Строка SMTP_PASSWORD не найдена в .env файле")
            
    except Exception as e:
        print(f"❌ Ошибка обновления .env файла: {e}")

def show_gmail_setup_instructions():
    """Показывает инструкции по настройке Gmail"""
    print("\n📋 ИНСТРУКЦИЯ ПО НАСТРОЙКЕ GMAIL APP PASSWORD:")
    print("-" * 60)
    print("1. Зайдите в Google Account: https://myaccount.google.com/security")
    print("2. Включите '2-Step Verification' если не включена")
    print("3. В разделе Security найдите 'App passwords'")
    print("4. Select app → Mail")
    print("5. Select device → Other → введите 'ChistaVoda Bot'")
    print("6. Нажмите Generate")
    print("7. Скопируйте 16-символьный пароль (без пробелов!)")
    print("8. Используйте ЭТОТ пароль (не основной пароль Gmail)")
    print("-" * 60)

if __name__ == "__main__":
    show_gmail_setup_instructions()
    test_gmail_connection()
