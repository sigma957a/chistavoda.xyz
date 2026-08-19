import smtplib
import os
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from dotenv import load_dotenv
from datetime import datetime

# Загружаем переменные окружения
load_dotenv()

# Настройки SMTP из .env
SMTP_SERVER = os.environ.get("SMTP_SERVER", "smtp.gmail.com")
SMTP_PORT = int(os.environ.get("SMTP_PORT", "587"))
SMTP_USERNAME = os.environ.get("SMTP_USERNAME")
SMTP_PASSWORD = os.environ.get("SMTP_PASSWORD")

def test_email_connection():
    """Тест подключения к SMTP серверу"""
    print("🔍 Проверка подключения к SMTP серверу...")
    print(f"📧 SMTP Server: {SMTP_SERVER}:{SMTP_PORT}")
    print(f"👤 Username: {SMTP_USERNAME}")
    print(f"🔑 Password: {'*' * len(SMTP_PASSWORD) if SMTP_PASSWORD else 'НЕ УСТАНОВЛЕН'}")
    
    if not SMTP_USERNAME or not SMTP_PASSWORD:
        print("❌ ОШИБКА: SMTP_USERNAME или SMTP_PASSWORD не установлены!")
        return False
    
    try:
        # Подключаемся к серверу
        print("\n🔄 Подключение к SMTP серверу...")
        server = smtplib.SMTP(SMTP_SERVER, SMTP_PORT)
        server.starttls()
        
        print("🔐 Авторизация...")
        server.login(SMTP_USERNAME, SMTP_PASSWORD)
        
        print("✅ Подключение успешно! SMTP работает корректно.")
        server.quit()
        return True
        
    except smtplib.SMTPAuthenticationError as e:
        print(f"❌ ОШИБКА АВТОРИЗАЦИИ: {e}")
        print("🔧 Возможные причины:")
        print("   • Неверный пароль приложения")
        print("   • Двухфакторная аутентификация не включена")
        print("   • Пароль приложения не создан в Google Account")
        return False
        
    except smtplib.SMTPException as e:
        print(f"❌ ОШИБКА SMTP: {e}")
        return False
        
    except Exception as e:
        print(f"❌ ОБЩАЯ ОШИБКА: {e}")
        return False

def send_test_email(to_email: str):
    """Отправка тестового email"""
    print(f"\n📤 Отправка тестового email на {to_email}...")
    
    try:
        # Создаем сообщение
        msg = MIMEMultipart("alternative")
        msg["Subject"] = "🧪 Тест уведомлений от системы ChиstaVoda"
        msg["From"] = SMTP_USERNAME
        msg["To"] = to_email
        
        # HTML версия письма
        html_body = f"""
        <html>
        <head></head>
        <body>
            <h2 style="color: #28a745;">🧪 Тестовое сообщение</h2>
            <div style="background-color: #f8f9fa; padding: 15px; border-radius: 5px; margin: 10px 0;">
                <p><strong>Время отправки:</strong> {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}</p>
                <p><strong>От:</strong> Система уведомлений ChistaVoda</p>
                <p><strong>Статус:</strong> ✅ SMTP настройки работают корректно!</p>
            </div>
            <div style="background-color: #d4edda; padding: 10px; border-radius: 5px; border-left: 4px solid #28a745;">
                <h3>✅ Настройки SMTP проверены:</h3>
                <ul>
                    <li>Сервер: {SMTP_SERVER}:{SMTP_PORT}</li>
                    <li>Авторизация: Успешно</li>
                    <li>Отправка: Работает</li>
                </ul>
            </div>
            <div style="margin-top: 20px; padding: 15px; background-color: #fff3cd; border-radius: 5px;">
                <h3>🔄 Что дальше:</h3>
                <p>1. Убедитесь, что email владельца добавлен в базу данных</p>
                <p>2. Зарегистрируйте владельца в Telegram через бота</p>
                <p>3. Протестируйте создание заявки через QR-код</p>
            </div>
            <hr>
            <p style="color: #6c757d; font-size: 12px;">
                Это автоматическое тестовое сообщение от системы мониторинга автоматов розлива воды ChistaVoda.
            </p>
        </body>
        </html>
        """
        
        msg.attach(MIMEText(html_body, "html", "utf-8"))
        
        # Отправляем email
        with smtplib.SMTP(SMTP_SERVER, SMTP_PORT) as server:
            server.starttls()
            server.login(SMTP_USERNAME, SMTP_PASSWORD)
            server.send_message(msg)
        
        print(f"✅ Тестовый email успешно отправлен на {to_email}!")
        print("📧 Проверьте почтовый ящик (включая папку Спам)")
        return True
        
    except Exception as e:
        print(f"❌ Ошибка отправки email: {e}")
        return False

def main():
    print("🧪 ТЕСТ EMAIL УВЕДОМЛЕНИЙ ChistaVoda")
    print("=" * 50)
    
    # Тест подключения
    if test_email_connection():
        print("\n" + "=" * 50)
        
        # Запрашиваем email для теста
        test_email_address = input("\n📧 Введите email для отправки тестового сообщения: ").strip()
        
        if test_email_address:
            if send_test_email(test_email_address):
                print("\n✅ ВСЕ ТЕСТЫ ПРОЙДЕНЫ УСПЕШНО!")
                print("🎉 SMTP настройки работают корректно!")
                print("\n🔧 Следующие шаги:")
                print("1. Обновите email владельца в базе данных")
                print("2. Зарегистрируйте владельца в Telegram")
                print("3. Протестируйте полный процесс создания заявки")
            else:
                print("\n❌ Отправка тестового email не удалась")
        else:
            print("❌ Email не введен")
    else:
        print("\n❌ ТЕСТ НЕ ПРОЙДЕН!")
        print("🔧 Исправьте настройки SMTP и попробуйте снова")
    
    print("\n" + "=" * 50)

if __name__ == "__main__":
    main()
