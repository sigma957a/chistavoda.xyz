import os

def update_env_with_gmail_password():
    """Обновляет .env файл с новым паролем приложения Gmail"""
    
    # Новый пароль приложения (без пробелов)
    new_password = "odnfnvamyxrvuznm"
    
    print("🔧 ОБНОВЛЕНИЕ .env ФАЙЛА С GMAIL APP PASSWORD")
    print("=" * 55)
    print(f"🔑 Новый пароль: {new_password[:4]}***{new_password[-4:]}")
    
    try:
        # Проверяем существование файла
        if not os.path.exists('.env'):
            print("❌ Файл .env не найден!")
            return False
        
        # Читаем текущий файл
        with open('.env', 'r', encoding='utf-8') as f:
            lines = f.readlines()
        
        # Обновляем пароль
        updated = False
        for i, line in enumerate(lines):
            if line.startswith('SMTP_PASSWORD='):
                old_password = line.strip().split('=', 1)[1] if '=' in line else 'не найден'
                lines[i] = f'SMTP_PASSWORD={new_password}\n'
                print(f"📝 Обновлено: SMTP_PASSWORD")
                print(f"   Старый: {old_password[:6]}***")
                print(f"   Новый:  {new_password[:6]}***")
                updated = True
                break
        
        if not updated:
            print("⚠️ Строка SMTP_PASSWORD не найдена в .env файле")
            return False
        
        # Записываем обновленный файл
        with open('.env', 'w', encoding='utf-8') as f:
            f.writelines(lines)
        
        print("✅ Файл .env успешно обновлен!")
        return True
        
    except Exception as e:
        print(f"❌ Ошибка обновления .env файла: {e}")
        return False

def verify_env_update():
    """Проверяет, что пароль обновился корректно"""
    from dotenv import load_dotenv
    
    print("\n🔍 ПРОВЕРКА ОБНОВЛЕНИЯ:")
    print("-" * 30)
    
    load_dotenv()
    
    smtp_password = os.environ.get('SMTP_PASSWORD')
    smtp_username = os.environ.get('SMTP_USERNAME')
    email_enabled = os.environ.get('EMAIL_ENABLED')
    
    print(f"📧 EMAIL_ENABLED: {email_enabled}")
    print(f"👤 SMTP_USERNAME: {smtp_username}")
    print(f"🔑 SMTP_PASSWORD: {smtp_password[:6]}*** (длина: {len(smtp_password) if smtp_password else 0})")
    
    # Проверяем корректность
    checks = []
    checks.append(("EMAIL_ENABLED = true", email_enabled == "true"))
    checks.append(("SMTP_USERNAME установлен", bool(smtp_username)))
    checks.append(("SMTP_PASSWORD = 16 символов", smtp_password and len(smtp_password) == 16))
    checks.append(("SMTP_PASSWORD без пробелов", smtp_password and ' ' not in smtp_password))
    
    print("\n📋 ПРОВЕРКИ:")
    all_ok = True
    for check_name, check_result in checks:
        status = "✅" if check_result else "❌"
        print(f"   {status} {check_name}")
        if not check_result:
            all_ok = False
    
    if all_ok:
        print("\n🎉 ВСЕ НАСТРОЙКИ КОРРЕКТНЫ!")
        print("🧪 Запустите: python3 test_email.py")
    else:
        print("\n❌ ЕСТЬ ПРОБЛЕМЫ В НАСТРОЙКАХ!")
    
    return all_ok

if __name__ == "__main__":
    if update_env_with_gmail_password():
        verify_env_update()
