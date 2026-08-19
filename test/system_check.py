#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
СКРИПТ ПРОВЕРКИ ЦЕЛОСТНОСТИ СИСТЕМЫ ЗАЯВОК v4.5
Проверяет все компоненты системы и выявляет потенциальные проблемы
"""

import os
import json
import asyncio
import psycopg2
from datetime import datetime
from dotenv import load_dotenv
from supabase import create_client
from typing import Dict, List, Any

# Загружаем переменные окружения
load_dotenv()

class SystemChecker:
    def __init__(self):
        self.issues = []
        self.warnings = []
        self.success = []
        
        # Настройки из переменных окружения
        self.supabase_url = os.getenv("SUPABASE_URL")
        self.supabase_key = os.getenv("SUPABASE_ANON_KEY")
        self.telegram_token = os.getenv("TELEGRAM_BOT_TOKEN")
        self.email_enabled = os.getenv("EMAIL_ENABLED", "false").lower() == "true"
        self.smtp_username = os.getenv("SMTP_USERNAME")
        self.smtp_password = os.getenv("SMTP_PASSWORD")
        
        # Подключение к Supabase
        if self.supabase_url and self.supabase_key:
            self.supabase = create_client(self.supabase_url, self.supabase_key)
        else:
            self.supabase = None

    def log_issue(self, message: str):
        """Добавить критическую проблему"""
        self.issues.append(f"❌ {message}")
        print(f"❌ {message}")

    def log_warning(self, message: str):
        """Добавить предупреждение"""
        self.warnings.append(f"⚠️ {message}")
        print(f"⚠️ {message}")

    def log_success(self, message: str):
        """Добавить успешную проверку"""
        self.success.append(f"✅ {message}")
        print(f"✅ {message}")

    def check_environment_variables(self):
        """Проверка переменных окружения"""
        print("\n🔍 ПРОВЕРКА ПЕРЕМЕННЫХ ОКРУЖЕНИЯ")
        print("=" * 50)
        
        required_vars = [
            ("TELEGRAM_BOT_TOKEN", self.telegram_token),
            ("SUPABASE_URL", self.supabase_url),
            ("SUPABASE_ANON_KEY", self.supabase_key),
            ("EMERGENCY_PHONE", os.getenv("EMERGENCY_PHONE")),
        ]
        
        for var_name, var_value in required_vars:
            if var_value:
                self.log_success(f"{var_name} настроен")
            else:
                self.log_issue(f"{var_name} отсутствует или пустой")
        
        # Проверка email настроек
        if self.email_enabled:
            if self.smtp_username and self.smtp_password:
                self.log_success("Email уведомления настроены")
            else:
                self.log_warning("Email включен, но SMTP настройки неполные")
        else:
            self.log_warning("Email уведомления отключены")

    def check_required_files(self):
        """Проверка необходимых файлов"""
        print("\n📁 ПРОВЕРКА ФАЙЛОВ")
        print("=" * 50)
        
        required_files = [
            "main.py",
            "texts.json",
            ".env",
        ]
        
        for file_path in required_files:
            if os.path.exists(file_path):
                self.log_success(f"Файл {file_path} найден")
            else:
                self.log_issue(f"Файл {file_path} отсутствует")
        
        # Проверка папки логов
        if not os.path.exists("logs"):
            self.log_warning("Папка logs не существует, будет создана автоматически")
            os.makedirs("logs", exist_ok=True)
            self.log_success("Папка logs создана")

    def check_texts_json(self):
        """Проверка файла texts.json"""
        print("\n📝 ПРОВЕРКА TEXTS.JSON")
        print("=" * 50)
        
        try:
            with open("texts.json", "r", encoding="utf-8") as f:
                texts = json.load(f)
            
            required_sections = ["messages", "buttons", "problems"]
            for section in required_sections:
                if section in texts:
                    self.log_success(f"Секция '{section}' найдена")
                else:
                    self.log_issue(f"Секция '{section}' отсутствует в texts.json")
            
            # Проверка ключевых сообщений
            required_messages = [
                "welcome",
                "start_without_code", 
                "machine_not_found",
                "ticket_created",
                "ticket_creation_error"
            ]
            
            messages = texts.get("messages", {})
            for msg_key in required_messages:
                if msg_key in messages:
                    self.log_success(f"Сообщение '{msg_key}' найдено")
                else:
                    self.log_warning(f"Сообщение '{msg_key}' отсутствует")
                    
        except FileNotFoundError:
            self.log_issue("Файл texts.json не найден")
        except json.JSONDecodeError as e:
            self.log_issue(f"Ошибка парсинга texts.json: {e}")

    async def check_database_connection(self):
        """Проверка подключения к базе данных"""
        print("\n🗄️ ПРОВЕРКА БАЗЫ ДАННЫХ")
        print("=" * 50)
        
        if not self.supabase:
            self.log_issue("Подключение к Supabase не настроено")
            return
        
        try:
            # Тест подключения
            response = self.supabase.table("machines").select("id").limit(1).execute()
            self.log_success("Подключение к Supabase работает")
            
            # Проверка основных таблиц
            required_tables = [
                "machines",
                "owners", 
                "support_tickets",
                "owner_notification_settings"
            ]
            
            for table_name in required_tables:
                try:
                    response = self.supabase.table(table_name).select("*").limit(1).execute()
                    self.log_success(f"Таблица '{table_name}' доступна")
                except Exception as e:
                    self.log_issue(f"Таблица '{table_name}' недоступна: {e}")
            
        except Exception as e:
            self.log_issue(f"Ошибка подключения к базе данных: {e}")

    async def check_database_structure(self):
        """Проверка структуры базы данных"""
        print("\n🏗️ ПРОВЕРКА СТРУКТУРЫ БД")
        print("=" * 50)
        
        if not self.supabase:
            return
        
        # Проверяем поля в support_tickets
        required_fields_support_tickets = [
            "id", "ticket_number", "user_id", "user_name", "user_phone",
            "problem_type", "problem_subcategory", "problem_level3", 
            "problem_description", "machine_id", "status", "priority",
            "assigned_to", "created_at", "updated_at", "resolved_at",
            "comments", "client_rating"
        ]
        
        try:
            # Получаем информацию о полях через SQL запрос
            response = self.supabase.rpc("get_table_columns", {
                "table_name": "support_tickets"
            }).execute()
            
            if response.data:
                existing_fields = [row["column_name"] for row in response.data]
                
                for field in required_fields_support_tickets:
                    if field in existing_fields:
                        self.log_success(f"Поле '{field}' существует в support_tickets")
                    else:
                        self.log_warning(f"Поле '{field}' отсутствует в support_tickets")
            else:
                self.log_warning("Не удалось получить структуру таблицы support_tickets")
                
        except Exception as e:
            self.log_warning(f"Ошибка проверки структуры БД: {e}")

    async def check_sample_data(self):
        """Проверка наличия тестовых данных"""
        print("\n📊 ПРОВЕРКА ДАННЫХ")
        print("=" * 50)
        
        if not self.supabase:
            return
        
        try:
            # Проверка автоматов
            machines = self.supabase.table("machines").select("*").execute()
            if machines.data:
                self.log_success(f"Найдено {len(machines.data)} автоматов")
                
                # Проверка, что у автоматов есть владельцы
                machines_with_owners = [m for m in machines.data if m.get("owner_id")]
                if machines_with_owners:
                    self.log_success(f"{len(machines_with_owners)} автоматов имеют владельцев")
                else:
                    self.log_warning("Ни один автомат не привязан к владельцу")
            else:
                self.log_warning("Автоматы не найдены в БД")
            
            # Проверка владельцев
            owners = self.supabase.table("owners").select("*").execute()
            if owners.data:
                self.log_success(f"Найдено {len(owners.data)} владельцев")
            else:
                self.log_warning("Владельцы не найдены в БД")
            
            # Проверка настроек уведомлений
            notifications = self.supabase.table("owner_notification_settings").select("*").execute()
            if notifications.data:
                self.log_success(f"Найдено {len(notifications.data)} настроек уведомлений")
                
                # Проверка Telegram ID
                with_telegram = [n for n in notifications.data if n.get("telegram_chat_id")]
                if with_telegram:
                    self.log_success(f"{len(with_telegram)} владельцев настроили Telegram")
                else:
                    self.log_warning("Ни один владелец не настроил Telegram уведомления")
            else:
                self.log_warning("Настройки уведомлений не найдены")
            
            # Проверка заявок
            tickets = self.supabase.table("support_tickets").select("*").limit(10).execute()
            if tickets.data:
                self.log_success(f"Найдено заявок в БД: {len(tickets.data)}")
            else:
                self.log_success("Заявок пока нет (это нормально для новой системы)")
                
        except Exception as e:
            self.log_issue(f"Ошибка проверки данных: {e}")

    def check_permissions(self):
        """Проверка прав доступа к файлам"""
        print("\n🔐 ПРОВЕРКА ПРАВ ДОСТУПА")
        print("=" * 50)
        
        # Проверка прав на запись в папку логов
        logs_dir = "logs"
        if os.path.exists(logs_dir):
            if os.access(logs_dir, os.W_OK):
                self.log_success("Права на запись в папку logs есть")
            else:
                self.log_issue("Нет прав на запись в папку logs")
        
        # Проверка прав на чтение основных файлов
        for file_path in ["main.py", "texts.json", ".env"]:
            if os.path.exists(file_path):
                if os.access(file_path, os.R_OK):
                    self.log_success(f"Права на чтение {file_path} есть")
                else:
                    self.log_issue(f"Нет прав на чтение {file_path}")

    async def check_telegram_bot(self):
        """Проверка Telegram бота"""
        print("\n🤖 ПРОВЕРКА TELEGRAM БОТА")
        print("=" * 50)
        
        if not self.telegram_token:
            self.log_issue("Токен Telegram бота не настроен")
            return
        
        try:
            import aiohttp
            
            async with aiohttp.ClientSession() as session:
                url = f"https://api.telegram.org/bot{self.telegram_token}/getMe"
                async with session.get(url) as response:
                    if response.status == 200:
                        data = await response.json()
                        if data.get("ok"):
                            bot_info = data.get("result", {})
                            bot_name = bot_info.get("username", "Unknown")
                            self.log_success(f"Telegram бот @{bot_name} доступен")
                        else:
                            self.log_issue("Telegram API вернул ошибку")
                    else:
                        self.log_issue(f"Ошибка доступа к Telegram API: {response.status}")
                        
        except ImportError:
            self.log_warning("aiohttp не установлен, проверка Telegram бота пропущена")
        except Exception as e:
            self.log_issue(f"Ошибка проверки Telegram бота: {e}")

    def check_code_integrity(self):
        """Проверка целостности кода"""
        print("\n🔍 ПРОВЕРКА КОДА")
        print("=" * 50)
        
        try:
            with open("main.py", "r", encoding="utf-8") as f:
                code = f.read()
            
            # Проверка ключевых функций
            required_functions = [
                "start_command",
                "handle_message", 
                "contact_received",
                "create_support_ticket_v3",
                "handle_owner_menu",
                "handle_callback_query",
                "send_email_notification",
                "send_telegram_notification"
            ]
            
            for func_name in required_functions:
                if f"def {func_name}" in code or f"async def {func_name}" in code:
                    self.log_success(f"Функция '{func_name}' найдена")
                else:
                    self.log_issue(f"Функция '{func_name}' отсутствует")
            
            # Проверка импортов
            required_imports = [
                "from telegram import",
                "from telegram.ext import", 
                "from supabase import",
                "from dotenv import",
                "import logging"
            ]
            
            for import_stmt in required_imports:
                if import_stmt in code:
                    self.log_success(f"Импорт '{import_stmt.strip()}' найден")
                else:
                    self.log_warning(f"Импорт '{import_stmt.strip()}' отсутствует")
            
            # Проверка режимов запуска
            if '/start owner' in code and '/start admin' in code:
                self.log_success("Поддержка режимов owner и admin найдена")
            else:
                self.log_warning("Не все режимы запуска поддерживаются")
                
        except FileNotFoundError:
            self.log_issue("Файл main.py не найден")
        except Exception as e:
            self.log_issue(f"Ошибка анализа кода: {e}")

    def generate_report(self):
        """Генерация итогового отчета"""
        print("\n" + "=" * 70)
        print("📋 ИТОГОВЫЙ ОТЧЕТ ПРОВЕРКИ СИСТЕМЫ")
        print("=" * 70)
        
        print(f"\n✅ Успешные проверки: {len(self.success)}")
        print(f"⚠️ Предупреждения: {len(self.warnings)}")
        print(f"❌ Критические проблемы: {len(self.issues)}")
        
        if self.issues:
            print("\n🚨 КРИТИЧЕСКИЕ ПРОБЛЕМЫ (требуют исправления):")
            for issue in self.issues:
                print(f"  {issue}")
        
        if self.warnings:
            print("\n⚠️ ПРЕДУПРЕЖДЕНИЯ (рекомендуется исправить):")
            for warning in self.warnings:
                print(f"  {warning}")
        
        print("\n🎯 РЕКОМЕНДАЦИИ:")
        if self.issues:
            print("1. Исправьте все критические проблемы перед запуском")
            print("2. Проверьте настройки переменных окружения")
            print("3. Убедитесь в наличии всех необходимых файлов")
        elif self.warnings:
            print("1. Рассмотрите возможность исправления предупреждений")
            print("2. Система готова к запуску с ограниченным функционалом")
        else:
            print("🎉 Система полностью готова к работе!")
        
        print("\n📞 ПОДДЕРЖКА:")
        print("При проблемах обратитесь к документации или разработчику")
        
        # Оценка готовности системы
        total_checks = len(self.success) + len(self.warnings) + len(self.issues)
        success_rate = (len(self.success) / total_checks * 100) if total_checks > 0 else 0
        
        print(f"\n📊 ГОТОВНОСТЬ СИСТЕМЫ: {success_rate:.1f}%")
        
        if success_rate >= 90:
            print("🟢 Отлично - система готова к продакшену")
        elif success_rate >= 70:
            print("🟡 Хорошо - система готова к тестированию")
        elif success_rate >= 50:
            print("🟠 Удовлетворительно - требуются доработки")
        else:
            print("🔴 Плохо - система не готова к использованию")

async def main():
    """Главная функция проверки"""
    print("🚀 ЗАПУСК ПРОВЕРКИ СИСТЕМЫ ЗАЯВОК v4.5")
    print(f"⏰ Время запуска: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print("=" * 70)
    
    checker = SystemChecker()
    
    # Выполняем все проверки
    checker.check_environment_variables()
    checker.check_required_files()
    checker.check_texts_json()
    await checker.check_database_connection()
    await checker.check_database_structure() 
    await checker.check_sample_data()
    checker.check_permissions()
    await checker.check_telegram_bot()
    checker.check_code_integrity()
    
    # Генерируем отчет
    checker.generate_report()

if __name__ == "__main__":
    asyncio.run(main())