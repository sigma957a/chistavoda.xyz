#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
СИСТЕМА ПОДДЕРЖКИ АВТОМАТОВ "ЧИСТАЯ ВОДА" v4.3
Telegram бот для приема обращений клиентов терминалов розлива воды
С трехуровневой навигацией и полной проверкой систем
"""

import os
import logging
import smtplib
import asyncio
import uuid
import psutil
import threading
import time
import json
from datetime import datetime, timedelta
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from dotenv import load_dotenv
from telegram import Update, ReplyKeyboardMarkup, KeyboardButton, ReplyKeyboardRemove, InlineKeyboardMarkup, InlineKeyboardButton
from telegram.ext import (
    Application,
    CommandHandler,
    MessageHandler,
    filters,
    CallbackContext,
    CallbackQueryHandler,
)
from supabase import create_client, Client
import re
import urllib.parse
from typing import Optional, Dict, Any, List

# --- CONFIGURATION LOADING ---
def load_texts():
    """Load texts from the texts.json file."""
    try:
        with open("texts.json", "r", encoding="utf-8") as f:
            return json.load(f)
    except FileNotFoundError:
        print("❌ texts.json not found! The bot cannot start.")
        exit()
    except json.JSONDecodeError:
        print("❌ Error decoding texts.json! Check the file for syntax errors.")
        exit()

# Global texts dictionary
TEXTS = load_texts()

# Класс для расширенного логирования
class EnhancedFormatter(logging.Formatter):
    """Расширенный форматтер для логов с дополнительной информацией"""
    
    def format(self, record):
        formatted = super().format(record)
        
        user_info = ""
        if hasattr(record, 'user_id') and record.user_id:
            user_info = f" [👤 {record.user_id}"
            if hasattr(record, 'username') and record.username:
                user_info += f"/{record.username}"
            if hasattr(record, 'session_id') and record.session_id:
                user_info += f" 🔗 {record.session_id[:8]}"
            user_info += "]"
        
        return formatted + user_info

# Класс для объяснения системных событий
class SystemExplainer:
    """Класс для объяснения технических терминов простым языком"""
    
    @classmethod
    def explain_db_operation(cls, operation: str) -> str:
        operations = {
            "SELECT": "📖 Чтение данных из базы",
            "INSERT": "➕ Добавление новой записи в базу",
            "UPDATE": "✏️ Обновление существующей записи",
            "DELETE": "🗑️ Удаление записи из базы"
        }
        return operations.get(operation.upper(), f"🔍 Операция БД: {operation}")

# Настройка логирования
def setup_logging():
    """Настройка системы логирования"""
    os.makedirs("logs", exist_ok=True)
    
    logger = logging.getLogger()
    logger.setLevel(logging.INFO)
    
    for handler in logger.handlers[:]:
        logger.removeHandler(handler)
    
    formatter = EnhancedFormatter(
        "%(asctime)s | %(levelname)-8s | %(name)-20s | %(message)s",
        datefmt="%Y-%m-%d %H:%M:%S"
    )
    
    today = datetime.now().strftime("%Y-%m-%d")
    file_handler = logging.FileHandler(
        f"logs/support_bot_{today}.log", 
        encoding="utf-8"
    )
    file_handler.setFormatter(formatter)
    file_handler.setLevel(logging.INFO)
    
    console_handler = logging.StreamHandler()
    console_handler.setFormatter(formatter)
    console_handler.setLevel(logging.INFO)
    
    logger.addHandler(file_handler)
    logger.addHandler(console_handler)
    
    return logger

logger = setup_logging()

# Система предзапуска с проверками
class PreStartupSystem:
    """Система проверок перед запуском бота"""
    
    @staticmethod
    def check_environment_variables() -> bool:
        """Проверка переменных окружения"""
        logger.info("🧪 ПРОВЕРКА ПЕРЕМЕННЫХ ОКРУЖЕНИЯ")
        logger.info("=" * 60)
        
        if os.path.exists(".env"):
            logger.info("✅ Файл .env найден")
            try:
                with open(".env", 'r', encoding='utf-8') as f:
                    content = f.read()
                    lines = [line.strip() for line in content.split('\n') if line.strip() and not line.startswith('#')]
                    logger.info(f"📄 В файле .env найдено {len(lines)} переменных")
            except Exception as e:
                logger.error(f"❌ Ошибка чтения .env файла: {e}")
                return False
        else:
            logger.warning("⚠️ Файл .env не найден - используются системные переменные")
        
        load_dotenv()
        logger.info("✅ Переменные окружения загружены")
        
        required_vars = {
            "TELEGRAM_BOT_TOKEN": "Токен Telegram бота",
            "SUPABASE_URL": "URL базы данных Supabase",
            "SUPABASE_ANON_KEY": "Ключ доступа к Supabase",
            "EMERGENCY_PHONE": "Номер экстренной поддержки",
            "EMAIL_ENABLED": "Включение email уведомлений",
            "SMTP_SERVER": "SMTP сервер для отправки email",
            "SMTP_PORT": "Порт SMTP сервера",
            "SMTP_USERNAME": "Логин для SMTP",
            "SMTP_PASSWORD": "Пароль для SMTP",
            "ADMIN_USER_IDS": "ID администраторов"
        }
        
        missing_vars = []
        for var, description in required_vars.items():
            value = os.environ.get(var)
            if not value:
                missing_vars.append(f"❌ {var} - {description}")
                logger.error(f"❌ Переменная {var} не найдена")
            else:
                # Скрываем секретные данные в логах
                display_value = value[:8] + "..." if len(value) > 8 and any(secret in var.lower() for secret in ["token", "key", "password"]) else value
                logger.info(f"✅ {var}: {display_value}")
        
        if missing_vars:
            logger.error("❌ Найдены недостающие переменные окружения:")
            for var in missing_vars:
                logger.error(f"   {var}")
            return False
        
        logger.info("📊 Результат: ✅ ПРОЙДЕНА")
        return True
    
    @staticmethod
    def check_supabase_connection() -> bool:
        """Проверка подключения к Supabase"""
        logger.info("🧪 ПРОВЕРКА ПОДКЛЮЧЕНИЯ К SUPABASE")
        logger.info("=" * 60)
        
        try:
            url = os.environ.get("SUPABASE_URL")
            key = os.environ.get("SUPABASE_ANON_KEY")
            
            logger.info(f"🌐 URL: {url}")
            logger.info(f"🔑 Key: {key[:20]}...")
            
            supabase = create_client(url, key)
            
            # Простая проверка подключения
            response = supabase.table("machines").select("count").limit(1).execute()
            logger.info("✅ Подключение к Supabase установлено")
            
            # Проверяем основные таблицы
            tables = ["machines", "owners", "support_tickets", "filter_replacements", "water_analyses"]
            for table in tables:
                try:
                    response = supabase.table(table).select("*").limit(1).execute()
                    logger.info(f"✅ Таблица '{table}' доступна")
                except Exception as e:
                    logger.warning(f"⚠️ Таблица '{table}' недоступна: {e}")
            
            logger.info("📊 Результат: ✅ ПРОЙДЕНА")
            return True
            
        except Exception as e:
            logger.error(f"❌ Ошибка подключения к Supabase: {e}")
            logger.error("📊 Результат: ❌ НЕ ПРОЙДЕНА")
            return False
    
    @staticmethod
    def check_smtp_connection() -> bool:
        """Проверка подключения к SMTP серверу Gmail"""
        logger.info("🧪 ПРОВЕРКА ПОДКЛЮЧЕНИЯ К SMTP (GMAIL)")
        logger.info("=" * 60)
        
        email_enabled = os.environ.get("EMAIL_ENABLED", "false").lower() == "true"
        
        if not email_enabled:
            logger.info("ℹ️ Email уведомления отключены (EMAIL_ENABLED=false)")
            logger.info("📊 Результат: ⏭️ ПРОПУЩЕНА")
            return True
        
        try:
            smtp_server = os.environ.get("SMTP_SERVER", "smtp.gmail.com")
            smtp_port = int(os.environ.get("SMTP_PORT", "587"))
            smtp_username = os.environ.get("SMTP_USERNAME")
            smtp_password = os.environ.get("SMTP_PASSWORD")
            
            logger.info(f"🌐 SMTP Server: {smtp_server}:{smtp_port}")
            logger.info(f"👤 Username: {smtp_username}")
            logger.info(f"🔐 Password: {'*' * len(smtp_password) if smtp_password else 'НЕ УКАЗАН'}")
            
            if not smtp_username or not smtp_password:
                logger.error("❌ SMTP_USERNAME или SMTP_PASSWORD не указаны")
                logger.error("📊 Результат: ❌ НЕ ПРОЙДЕНА")
                return False
            
            # Проверяем подключение к SMTP серверу
            logger.info("🔄 Подключение к SMTP серверу...")
            server = smtplib.SMTP(smtp_server, smtp_port)
            server.starttls()
            logger.info("✅ TLS соединение установлено")
            
            # Проверяем аутентификацию
            logger.info("🔄 Проверка аутентификации...")
            server.login(smtp_username, smtp_password)
            logger.info("✅ Аутентификация успешна")
            
            server.quit()
            logger.info("✅ SMTP подключение работает корректно")
            logger.info("📊 Результат: ✅ ПРОЙДЕНА")
            return True
            
        except smtplib.SMTPAuthenticationError as e:
            logger.error(f"❌ Ошибка аутентификации SMTP: {e}")
            logger.error("💡 Проверьте SMTP_USERNAME, SMTP_PASSWORD и настройки App Password в Gmail")
            logger.error("📊 Результат: ❌ НЕ ПРОЙДЕНА")
            return False
        except Exception as e:
            logger.error(f"❌ Ошибка подключения к SMTP: {e}")
            logger.error("📊 Результат: ❌ НЕ ПРОЙДЕНА")
            return False
    
    @staticmethod
    def check_texts_file() -> bool:
        """Проверка файла texts.json"""
        logger.info("🧪 ПРОВЕРКА ФАЙЛА TEXTS.JSON")
        logger.info("=" * 60)
        
        try:
            if not os.path.exists("texts.json"):
                logger.error("❌ Файл texts.json не найден")
                return False
            
            with open("texts.json", "r", encoding="utf-8") as f:
                texts = json.load(f)
            
            required_sections = ["emojis", "main_menu", "subcategories", "level3_categories", "messages", "buttons"]
            for section in required_sections:
                if section in texts:
                    logger.info(f"✅ Секция '{section}' найдена")
                else:
                    logger.error(f"❌ Секция '{section}' отсутствует")
                    return False
            
            # Проверяем трехуровневую структуру
            level3_count = sum(len(categories) for categories in texts.get("level3_categories", {}).values())
            logger.info(f"🎯 Найдено проблем 3-го уровня: {level3_count}")
            
            if level3_count > 50:
                logger.info("✅ Трехуровневая структура загружена корректно")
            else:
                logger.warning("⚠️ Мало проблем 3-го уровня - возможно не все данные загружены")
            
            logger.info("📊 Результат: ✅ ПРОЙДЕНА")
            return True
            
        except json.JSONDecodeError as e:
            logger.error(f"❌ Ошибка парсинга JSON: {e}")
            return False
        except Exception as e:
            logger.error(f"❌ Ошибка чтения файла: {e}")
            return False
    
    @classmethod
    def run_all_checks(cls) -> bool:
        """Запуск всех проверок"""
        logger.info("🚀 ЗАПУСК SUPPORT BOT V4.3 - ТРЕХУРОВНЕВАЯ НАВИГАЦИЯ")
        logger.info("=" * 70)
        
        checks = [
            cls.check_environment_variables,
            cls.check_supabase_connection,
            cls.check_smtp_connection,
            cls.check_texts_file
        ]
        
        all_passed = True
        for check in checks:
            if not check():
                all_passed = False
        
        if all_passed:
            logger.info("\n🎉 ВСЕ ПРОВЕРКИ ПРОЙДЕНЫ УСПЕШНО!")
            logger.info("🚀 Система готова к запуску бота")
        else:
            logger.error("\n❌ НЕКОТОРЫЕ ПРОВЕРКИ НЕ ПРОЙДЕНЫ!")
            logger.error("🔧 Исправьте проблемы перед запуском бота")
        
        logger.info("=" * 70)
        return all_passed

# Загрузка переменных окружения
load_dotenv()

# Конфигурация
TOKEN = os.environ.get("TELEGRAM_BOT_TOKEN")
SUPABASE_URL = os.environ.get("SUPABASE_URL")
SUPABASE_KEY = os.environ.get("SUPABASE_ANON_KEY")
EMAIL_ENABLED = os.environ.get("EMAIL_ENABLED", "false").lower() == "true"
SMTP_SERVER = os.environ.get("SMTP_SERVER", "smtp.gmail.com")
SMTP_PORT = int(os.environ.get("SMTP_PORT", "587"))
SMTP_USERNAME = os.environ.get("SMTP_USERNAME")
SMTP_PASSWORD = os.environ.get("SMTP_PASSWORD")
EMERGENCY_PHONE = os.environ.get("EMERGENCY_PHONE", "050-777-30-15")

# Администраторы бота
ADMIN_USER_IDS = []
admin_ids_str = os.environ.get("ADMIN_USER_IDS", "")
if admin_ids_str:
    try:
        ADMIN_USER_IDS = [int(id.strip()) for id in admin_ids_str.split(",") if id.strip()]
        logger.info(f"📋 Настроены администраторы: {ADMIN_USER_IDS}")
    except:
        logger.warning("⚠️ Ошибка парсинга ID администраторов")

# Инициализация Supabase
supabase: Client = None

# Трехуровневая структура категорий проблем
PROBLEM_CATEGORIES = {
    "machine_offline": {
        "subcategories": TEXTS["subcategories"]["machine_offline"],
        "has_level3": True
    },
    "payment_issue": {
        "subcategories": TEXTS["subcategories"]["payment_issue"],
        "has_level3": True
    },
    "water_quality": {
        "subcategories": TEXTS["subcategories"]["water_quality"],
        "has_level3": True
    },
    "emergency": {
        "subcategories": TEXTS["subcategories"]["emergency"],
        "has_level3": True
    },
    "technical_issue": {
        "subcategories": {},
        "has_level3": False
    },
    "other": {
        "subcategories": {},
        "has_level3": False
    }
}

def is_admin(user_id: int) -> bool:
    """Проверка является ли пользователь администратором"""
    return user_id in ADMIN_USER_IDS

# Декоратор для проверки прав администратора
def admin_required(func):
    async def wrapper(update: Update, context: CallbackContext, *args, **kwargs):
        user_id = update.effective_user.id
        if not is_admin(user_id):
            await update.message.reply_text(
                "❌ <b>Доступ заборонено</b>\n\n"
                "Ця функція доступна тільки адміністраторам.",
                parse_mode="HTML"
            )
            return
        return await func(update, context, *args, **kwargs)
    return wrapper

# Декоратор для логирования действий пользователей
def log_user_action(action_name: str):
    def decorator(func):
        async def wrapper(update: Update, context: CallbackContext, *args, **kwargs):
            user = update.effective_user
            session_id = str(uuid.uuid4())
            
            # Создаем адаптер для логгера с дополнительной информацией
            log_adapter = logging.LoggerAdapter(logger, {
                'user_id': user.id,
                'username': user.full_name,
                'session_id': session_id
            })
            
            start_time = time.time()
            log_adapter.info(f"🚀 Начало действия: {action_name}")
            
            try:
                result = await func(update, context, *args, **kwargs)
                execution_time = time.time() - start_time
                log_adapter.info(f"✅ Успешное завершение: {action_name} ({execution_time:.3f}s)")
                return result
            except Exception as e:
                execution_time = time.time() - start_time
                log_adapter.error(f"❌ Ошибка в {action_name} ({execution_time:.3f}s): {e}")
                raise
                
        return wrapper
    return decorator

def validate_email(email: str) -> bool:
    """Проверка корректности email адреса"""
    if not email:
        return False
    pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    return bool(re.match(pattern, email))

# --- HELPER FUNCTIONS ---

def clean_text_from_emoji(text: str, emoji_dict: dict) -> str:
    """Удаляет эмодзи из текста для поиска в словарях"""
    clean_text = text
    for emoji in emoji_dict.values():
        if text.startswith(emoji):
            clean_text = text[len(emoji):].strip()
            break
    return clean_text

def build_problem_chain(user_data: dict) -> str:
    """Строит полную цепочку проблемы для отображения"""
    chain_parts = []
    
    if "problem_category_text" in user_data:
        # Убираем эмодзи из категории
        category_text = user_data["problem_category_text"]
        for emoji in TEXTS["emojis"].values():
            if category_text.startswith(emoji):
                category_text = category_text[len(emoji):].strip()
                break
        chain_parts.append(category_text)
    
    if "problem_subcategory_text" in user_data:
        chain_parts.append(user_data["problem_subcategory_text"])
    
    if "problem_level3_text" in user_data:
        chain_parts.append(user_data["problem_level3_text"])
    
    return " → ".join(chain_parts)

def log_navigation_state(user_data: dict, stage: str):
    """Логирование состояния навигации для отладки"""
    logger.info(f"🧭 Навигация - Стадия: {stage}")
    
    if "problem_category_key" in user_data:
        logger.info(f"📁 Категория: {user_data['problem_category_key']}")
    
    if "problem_subcategory_code" in user_data:
        logger.info(f"📂 Подкатегория: {user_data['problem_subcategory_code']}")
    
    if "problem_level3_code" in user_data:
        logger.info(f"📋 Уровень 3: {user_data['problem_level3_code']}")
    
    if "problem_description" in user_data:
        logger.info(f"💬 Описание: {user_data['problem_description'][:50]}...")

def clean_user_navigation_data(user_data: dict):
    """Очистка данных навигации при возврате в главное меню"""
    keys_to_remove = [
        "problem_category_key", "problem_category_text",
        "problem_subcategory_code", "problem_subcategory_text", 
        "problem_level3_code", "problem_level3_text",
        "problem_description"
    ]
    
    for key in keys_to_remove:
        user_data.pop(key, None)

# --- KEYBOARD FUNCTIONS ---

def get_main_menu_keyboard():
    """Главное меню с выбором проблемы (Уровень 1)"""
    buttons = TEXTS["main_menu"]
    emojis = TEXTS["emojis"]
    
    keyboard = [
        [f"{emojis['machine_offline']} {buttons['machine_offline']}", f"{emojis['payment_issue']} {buttons['payment_issue']}"],
        [f"{emojis['water_quality']} {buttons['water_quality']}", f"{emojis['technical_issue']} {buttons['technical_issue']}"],
        [f"{emojis['water_info']} {buttons['water_info']}", f"{emojis['other']} {buttons['other']}"],
        [f"{emojis['emergency']} {buttons['emergency']}"]
    ]
    return ReplyKeyboardMarkup(keyboard, resize_keyboard=True, one_time_keyboard=True)

def get_subcategory_keyboard(category_key: str):
    """Клавиатура подкатегорий (Уровень 2) с эмодзи и двухколоночным расположением"""
    subcategories = TEXTS["subcategories"].get(category_key, {})
    subcategory_emojis = TEXTS["subcategory_emojis"].get(category_key, {})
    
    keyboard = []
    subcategory_items = list(subcategories.items())
    
    # Создаем кнопки с эмодзи
    buttons_with_emojis = []
    for subcategory_text, subcategory_code in subcategory_items:
        emoji = subcategory_emojis.get(subcategory_code, "🔹")
        button_text = f"{emoji} {subcategory_text}"
        buttons_with_emojis.append(button_text)
    
    # Разбиваем кнопки на пары для двухколоночного отображения
    for i in range(0, len(buttons_with_emojis), 2):
        if i + 1 < len(buttons_with_emojis):
            keyboard.append([buttons_with_emojis[i], buttons_with_emojis[i + 1]])
        else:
            keyboard.append([buttons_with_emojis[i]])
    
    # Добавляем кнопку "Назад"
    keyboard.append([TEXTS["buttons"]["back_to_problem_choice"]])
    
    return ReplyKeyboardMarkup(keyboard, resize_keyboard=True, one_time_keyboard=True)

def get_level3_keyboard(subcategory_code: str):
    """Клавиатура 3-го уровня с конкретными проблемами"""
    level3_categories = TEXTS["level3_categories"].get(subcategory_code, {})
    level3_emojis = TEXTS["level3_emojis"].get(subcategory_code, {})
    
    keyboard = []
    level3_items = list(level3_categories.items())
    
    # Создаем кнопки с эмодзи
    buttons_with_emojis = []
    for level3_text, level3_code in level3_items:
        emoji = level3_emojis.get(level3_code, "🔸")
        button_text = f"{emoji} {level3_text}"
        buttons_with_emojis.append(button_text)
    
    # Разбиваем кнопки на пары для двухколоночного отображения
    for i in range(0, len(buttons_with_emojis), 2):
        if i + 1 < len(buttons_with_emojis):
            keyboard.append([buttons_with_emojis[i], buttons_with_emojis[i + 1]])
        else:
            keyboard.append([buttons_with_emojis[i]])
    
    # Добавляем кнопку "Назад"
    keyboard.append([TEXTS["buttons"]["back_to_subcategory_choice"]])
    
    return ReplyKeyboardMarkup(keyboard, resize_keyboard=True, one_time_keyboard=True)

def get_water_quality_keyboard():
    """Клавиатура для меню качества воды"""
    water_menu = TEXTS["water_quality_menu"]
    
    keyboard = [
        [f"🔧 {water_menu['filter_history']}", f"📊 {water_menu['water_analysis']}"],
        [f"🔙 {water_menu['back_to_main']}"]
    ]
    return ReplyKeyboardMarkup(keyboard, resize_keyboard=True, one_time_keyboard=True)

def get_description_keyboard(navigation_level: str = "main"):
    """Клавиатура для этапа описания с учетом уровня навигации"""
    keyboard = [
        [TEXTS["buttons"]["skip"]]
    ]
    
    if navigation_level == "level3":
        keyboard.append([TEXTS["buttons"]["back_to_level3_choice"]])
    elif navigation_level == "subcategory":
        keyboard.append([TEXTS["buttons"]["back_to_subcategory_choice"]])
    else:
        keyboard.append([TEXTS["buttons"]["back_to_problem_choice"]])
    
    return ReplyKeyboardMarkup(keyboard, resize_keyboard=True, one_time_keyboard=True)

def get_admin_keyboard():
    """Клавиатура для администраторов с двухколоночным расположением"""
    keyboard = [
        ["👥 Список власників", "📊 Статистика"],
        ["➕ Додати власника", "❌ Видалити власника"],
        ["🔙 Назад"]
    ]
    return ReplyKeyboardMarkup(keyboard, resize_keyboard=True)

# --- WATER QUALITY FUNCTIONS ---

async def show_water_quality_info(update: Update, context: CallbackContext):
    """Показать информацию о качестве воды"""
    user_data = context.user_data
    user_data["stage"] = "water_quality"
    
    reply_markup = get_water_quality_keyboard()
    await update.message.reply_text(
        TEXTS["messages"]["water_quality_info"],
        reply_markup=reply_markup,
        parse_mode="HTML"
    )

async def handle_water_quality_menu(update: Update, context: CallbackContext, text: str):
    """Обработка меню качества воды"""
    user_data = context.user_data
    machine_id = user_data.get("machine_id")
    
    if text.endswith(TEXTS["water_quality_menu"]["filter_history"]):
        # Получаем историю замены фильтров
        try:
            response = supabase.table("filter_replacements").select("*").eq("machine_id", machine_id).order("replacement_date", desc=True).limit(5).execute()
            
            if response.data:
                history_text = "🔧 <b>ІСТОРІЯ ЗАМІНИ ФІЛЬТРІВ</b>\n\n"
                for record in response.data:
                    date = record.get('replacement_date', 'Невідомо')
                    filter_type = record.get('filter_type', 'Невідомий тип')
                    replaced_by = record.get('replaced_by', 'Невідомо')
                    
                    history_text += f"📅 <b>{date}</b>\n"
                    history_text += f"🔧 <i>{filter_type}</i>\n"
                    history_text += f"👤 {replaced_by}\n\n"
            else:
                history_text = "ℹ️ <b>Інформація про заміну фільтрів поки недоступна</b>"
                
        except Exception as e:
            logger.error(f"❌ Ошибка получения истории фильтров: {e}")
            history_text = "❌ <b>Помилка отримання даних</b>"
        
        await update.message.reply_text(
            history_text,
            parse_mode="HTML"
        )
        
    elif text.endswith(TEXTS["water_quality_menu"]["water_analysis"]):
        # Получаем данные анализов воды
        try:
            response = supabase.table("water_analyses").select("*").eq("machine_id", machine_id).order("analysis_date", desc=True).limit(3).execute()
            
            if response.data:
                analysis_text = "📊 <b>АНАЛІЗИ ВОДИ</b>\n\n"
                for record in response.data:
                    date = record.get('analysis_date', 'Невідомо')
                    laboratory = record.get('laboratory', 'Невідомо')
                    ph_level = record.get('ph_level', 'N/A')
                    tds_ppm = record.get('tds_ppm', 'N/A')
                    
                    analysis_text += f"📅 <b>{date}</b>\n"
                    analysis_text += f"🏢 <i>{laboratory}</i>\n"
                    analysis_text += f"🧪 pH: {ph_level}, TDS: {tds_ppm} ppm\n\n"
            else:
                analysis_text = "ℹ️ <b>Аналізи води поки недоступні</b>"
                
        except Exception as e:
            logger.error(f"❌ Ошибка получения анализов воды: {e}")
            analysis_text = "❌ <b>Помилка отримання даних</b>"
        
        await update.message.reply_text(
            analysis_text,
            parse_mode="HTML"
        )
        
    elif text.endswith(TEXTS["water_quality_menu"]["back_to_main"]):
        # Возвращаемся в главное меню
        user_data["stage"] = "main_menu"
        reply_markup = get_main_menu_keyboard()
        await update.message.reply_text(
            TEXTS["messages"]["back_to_main_menu"].format(address=user_data.get('machine_address', 'Невідомий')),
            reply_markup=reply_markup,
            parse_mode="HTML"
        )

# --- SYSTEM MONITORING ---

def log_system_metrics():
    """Логирование системных метрик"""
    try:
        cpu_percent = psutil.cpu_percent()
        memory = psutil.virtual_memory()
        disk = psutil.disk_usage('/')
        
        logger.info(
            f"📊 Системные метрики - "
            f"CPU: {cpu_percent}%, "
            f"RAM: {memory.percent}%, "
            f"Disk: {disk.percent}%"
        )
    except Exception as e:
        logger.error(f"❌ Ошибка получения системных метрик: {e}")

def start_monitoring():
    """Запуск мониторинга системы в отдельном потоке"""
    def monitor():
        while True:
            log_system_metrics()
            time.sleep(300)  # Каждые 5 минут
    
    thread = threading.Thread(target=monitor, daemon=True)
    thread.start()
    logger.info("📊 Запущен поток логирования метрик (каждые 5 минут)")

# --- DATABASE FUNCTIONS ---

async def get_machine_by_code(machine_code: str) -> Optional[Dict[str, Any]]:
    """Получение данных автомата по коду"""
    try:
        logger.info(f"🔍 Поиск автомата с кодом: {machine_code}")
        logger.info(f"🗄️ {SystemExplainer.explain_db_operation('SELECT')} из таблицы machines")
        
        response = supabase.table("machines").select("*").eq("code", machine_code).execute()
        
        if response.data:
            machine = response.data[0]
            logger.info(f"✅ Автомат найден: {machine.get('machine_id', 'Unknown')} - {machine.get('street', 'Unknown')}")
            return machine
        else:
            logger.warning(f"⚠️ Автомат с кодом {machine_code} не найден")
            return None
            
    except Exception as e:
        logger.error(f"❌ Ошибка поиска автомата: {e}")
        return None

async def get_owner_by_id(owner_id: int) -> Optional[Dict[str, Any]]:
    """Получение данных владельца по ID"""
    try:
        logger.info(f"👤 {SystemExplainer.explain_db_operation('SELECT')} владельца ID: {owner_id}")
        
        response = supabase.table("owners").select("*").eq("owner_id", owner_id).execute()
        
        if response.data:
            owner = response.data[0]
            logger.info(f"✅ Владелец найден: {owner.get('first_name', '')} {owner.get('last_name', '')}")
            return owner
        else:
            logger.warning(f"⚠️ Владелец с ID {owner_id} не найден")
            return None
            
    except Exception as e:
        logger.error(f"❌ Ошибка поиска владельца: {e}")
        return None

async def create_support_ticket_v3(user_data: Dict[str, Any]) -> Optional[str]:
    """Создание заявки с поддержкой трехуровневой структуры"""
    try:
        # Генерируем номер заявки
        current_year = datetime.now().year
        
        response = supabase.table("support_tickets")\
            .select("ticket_number")\
            .like("ticket_number", f"ST-{current_year}-%")\
            .order("created_at", desc=True)\
            .limit(1)\
            .execute()
        
        if response.data:
            last_ticket = response.data[0]["ticket_number"]
            last_number = int(last_ticket.split("-")[-1])
            new_number = last_number + 1
        else:
            new_number = 1
        
        ticket_number = f"ST-{current_year}-{new_number:04d}"
        
        # Формируем полный текст проблемы с трехуровневой структурой
        problem_full_text = build_problem_chain(user_data)
        
        # Создаем заявку
        ticket_data = {
            "ticket_number": ticket_number,
            "user_id": user_data["user_id"],
            "user_name": user_data["user_name"],
            "user_phone": user_data["user_phone"],
            "problem_type": user_data["problem_category_key"],
            "problem_subcategory": user_data.get("problem_subcategory_code"),
            "problem_level3": user_data.get("problem_level3_code"),  # Новое поле
            "problem_description": user_data.get("problem_description", ""),
            "machine_id": user_data["machine_id"],
            "assigned_to": user_data.get("owner_id"),
            "status": "new",
            "priority": "normal",
            "severity_level": "normal"
        }
        
        logger.info(f"➕ {SystemExplainer.explain_db_operation('INSERT')} заявки {ticket_number}")
        logger.info(f"📋 Проблема: {problem_full_text}")
        
        response = supabase.table("support_tickets").insert(ticket_data).execute()
        
        if response.data:
            logger.info(f"✅ Заявка {ticket_number} успешно создана")
            return ticket_number
        else:
            logger.error("❌ Ошибка создания заявки в базе данных")
            return None
            
    except Exception as e:
        logger.error(f"❌ Ошибка создания заявки: {e}")
        return None

# --- EMAIL NOTIFICATIONS ---

async def send_email_notification(owner_data: Dict[str, Any], ticket_data: Dict[str, Any]):
    """Отправка email уведомления владельцу"""
    if not EMAIL_ENABLED or not owner_data.get("email"):
        return
    
    try:
        subject = f"🚨 Нова заявка #{ticket_data['ticket_number']}"
        
        body = f"""
        <h2>🚨 Нова заявка в системі підтримки</h2>
        
        <p><strong>Номер заявки:</strong> #{ticket_data['ticket_number']}</p>
        <p><strong>Час створення:</strong> {datetime.now().strftime('%d.%m.%Y %H:%M')}</p>
        
        <h3>📍 Автомат</h3>
        <p><strong>Адреса:</strong> {ticket_data['machine_address']}</p>
        <p><strong>Код:</strong> {ticket_data['machine_code']}</p>
        
        <h3>🔧 Проблема</h3>
        <p><strong>Тип:</strong> {ticket_data['problem_full_text']}</p>
        <p><strong>Опис:</strong> {ticket_data.get('problem_description', 'Без опису')}</p>
        
        <h3>👤 Клієнт</h3>
        <p><strong>Ім'я:</strong> {ticket_data['user_name']}</p>
        <p><strong>Телефон:</strong> {ticket_data['user_phone']}</p>
        
        <p><em>Будь ласка, зв'яжіться з клієнтом найближчим часом.</em></p>
        """
        
        msg = MIMEMultipart()
        msg['From'] = SMTP_USERNAME
        msg['To'] = owner_data["email"]
        msg['Subject'] = subject
        
        msg.attach(MIMEText(body, 'html', 'utf-8'))
        
        server = smtplib.SMTP(SMTP_SERVER, SMTP_PORT)
        server.starttls()
        server.login(SMTP_USERNAME, SMTP_PASSWORD)
        
        text = msg.as_string()
        server.sendmail(SMTP_USERNAME, owner_data["email"], text)
        server.quit()
        
        logger.info(f"📧 Email уведомление отправлено на {owner_data['email']}")
        
    except Exception as e:
        logger.error(f"❌ Ошибка отправки email: {e}")

async def send_telegram_notification(owner_data: Dict[str, Any], ticket_data: Dict[str, Any], context: CallbackContext):
    """Отправка Telegram уведомления владельцу"""
    if not owner_data.get("telegram_id"):
        return
    
    try:
        message_text = f"""
🚨 <b>НОВА ЗАЯВКА #{ticket_data['ticket_number']}</b>

📍 <b>Автомат:</b> {ticket_data['machine_address']}
🔧 <b>Проблема:</b> {ticket_data['problem_full_text']}

👤 <b>Клієнт:</b> {ticket_data['user_name']}
📞 <b>Телефон:</b> {ticket_data['user_phone']}

🕐 <b>Час:</b> {datetime.now().strftime('%d.%m.%Y %H:%M')}

<i>Зв'яжіться з клієнтом найближчим часом!</i>
        """
        
        await context.bot.send_message(
            chat_id=owner_data["telegram_id"],
            text=message_text,
            parse_mode="HTML"
        )
        
        logger.info(f"📱 Telegram уведомление отправлено владельцу")
        
    except Exception as e:
        logger.error(f"❌ Ошибка отправки Telegram уведомления: {e}")

# --- MESSAGE HANDLERS ---

async def handle_main_menu(update: Update, context: CallbackContext, text: str):
    """Обработка главного меню (Уровень 1)"""
    user_data = context.user_data
    
    # Поиск категории по тексту
    category_key = None
    for key, value in TEXTS["main_menu"].items():
        if text.endswith(value):
            category_key = key
            break

    if text.endswith(TEXTS["main_menu"]["water_info"]):
        await show_water_quality_info(update, context)
        return

    if category_key and category_key in PROBLEM_CATEGORIES:
        problem_info = PROBLEM_CATEGORIES[category_key]
        
        user_data["problem_category_key"] = category_key
        user_data["problem_category_text"] = text
        
        if problem_info["subcategories"]:
            # Есть подкатегории - переходим на уровень 2
            user_data["stage"] = "subcategory"
            reply_markup = get_subcategory_keyboard(category_key)
            await update.message.reply_text(
                TEXTS["messages"]["choose_problem_details"],
                reply_markup=reply_markup,
                parse_mode="HTML",
            )
        else:
            # Нет подкатегорий - сразу к описанию
            user_data["stage"] = "description"
            reply_markup = get_description_keyboard("main")
            
            if category_key == "emergency":
                await update.message.reply_text(
                    TEXTS["messages"]["emergency_help"].format(phone=EMERGENCY_PHONE),
                    reply_markup=reply_markup,
                    parse_mode="HTML",
                    disable_web_page_preview=True,
                )
            else:
                await update.message.reply_text(
                    TEXTS["messages"]["problem_chosen"].format(problem=text),
                    reply_markup=reply_markup,
                    parse_mode="HTML",
                )
    else:
        await update.message.reply_text(
            TEXTS["messages"]["choose_option"].format(phone=EMERGENCY_PHONE),
            parse_mode="HTML",
        )

async def handle_subcategory_selection(update: Update, context: CallbackContext, text: str):
    """Обработка выбора подкатегории (Уровень 2)"""
    user_data = context.user_data
    
    if text == TEXTS["buttons"]["back_to_problem_choice"]:
        user_data["stage"] = "main_menu"
        reply_markup = get_main_menu_keyboard()
        await update.message.reply_text(
            TEXTS["messages"]["back_to_main_menu"].format(address=user_data.get('machine_address')),
            reply_markup=reply_markup,
            parse_mode="HTML",
        )
        return
    
    category_key = user_data.get("problem_category_key", "")
    subcategories = TEXTS["subcategories"].get(category_key, {})
    subcategory_emojis = TEXTS["subcategory_emojis"].get(category_key, {})
    
    # Убираем эмодзи из текста
    clean_text = clean_text_from_emoji(text, subcategory_emojis)
    
    # Проверяем без эмодзи (обратная совместимость)
    if clean_text not in subcategories and text in subcategories:
        clean_text = text
    
    if clean_text in subcategories:
        subcategory_code = subcategories[clean_text]
        user_data["problem_subcategory_code"] = subcategory_code
        user_data["problem_subcategory_text"] = clean_text
        
        # Проверяем, есть ли 3-й уровень
        level3_categories = TEXTS["level3_categories"].get(subcategory_code, {})
        
        if level3_categories:
            # Есть 3-й уровень - переходим к нему
            user_data["stage"] = "level3"
            reply_markup = get_level3_keyboard(subcategory_code)
            await update.message.reply_text(
                TEXTS["messages"]["subcategory_chosen"].format(subcategory=clean_text),
                reply_markup=reply_markup,
                parse_mode="HTML",
            )
        else:
            # Нет 3-го уровня - сразу к описанию
            user_data["stage"] = "description"
            reply_markup = get_description_keyboard("subcategory")
            await update.message.reply_text(
                TEXTS["messages"]["subcategory_chosen"].format(subcategory=clean_text),
                reply_markup=reply_markup,
                parse_mode="HTML",
            )
    else:
        await update.message.reply_text(
            TEXTS["messages"]["choose_option"].format(phone=EMERGENCY_PHONE),
            parse_mode="HTML",
        )

async def handle_level3_selection(update: Update, context: CallbackContext, text: str):
    """Обработка выбора конкретной проблемы (Уровень 3)"""
    user_data = context.user_data
    
    if text == TEXTS["buttons"]["back_to_subcategory_choice"]:
        user_data["stage"] = "subcategory"
        category_key = user_data.get("problem_category_key", "")
        reply_markup = get_subcategory_keyboard(category_key)
        await update.message.reply_text(
            TEXTS["messages"]["choose_problem_details"],
            reply_markup=reply_markup,
            parse_mode="HTML",
        )
        return
    
    subcategory_code = user_data.get("problem_subcategory_code", "")
    level3_categories = TEXTS["level3_categories"].get(subcategory_code, {})
    level3_emojis = TEXTS["level3_emojis"].get(subcategory_code, {})
    
    # Убираем эмодзи из текста
    clean_text = clean_text_from_emoji(text, level3_emojis)
    
    # Проверяем без эмодзи (обратная совместимость)
    if clean_text not in level3_categories and text in level3_categories:
        clean_text = text
    
    if clean_text in level3_categories:
        level3_code = level3_categories[clean_text]
        user_data["problem_level3_code"] = level3_code
        user_data["problem_level3_text"] = clean_text
        user_data["stage"] = "description"
        
        reply_markup = get_description_keyboard("level3")
        await update.message.reply_text(
            TEXTS["messages"]["level3_chosen"].format(level3_problem=clean_text),
            reply_markup=reply_markup,
            parse_mode="HTML",
        )
    else:
        await update.message.reply_text(
            TEXTS["messages"]["choose_option"].format(phone=EMERGENCY_PHONE),
            parse_mode="HTML",
        )

async def handle_description_stage(update: Update, context: CallbackContext, text: str):
    """Обработка этапа описания проблемы"""
    user_data = context.user_data

    # Обработка кнопок навигации назад
    if text == TEXTS["buttons"]["back_to_level3_choice"]:
        user_data["stage"] = "level3"
        subcategory_code = user_data.get("problem_subcategory_code", "")
        reply_markup = get_level3_keyboard(subcategory_code)
        await update.message.reply_text(
            TEXTS["messages"]["choose_specific_problem"],
            reply_markup=reply_markup,
            parse_mode="HTML",
        )
        return
    
    if text == TEXTS["buttons"]["back_to_subcategory_choice"]:
        user_data["stage"] = "subcategory"
        category_key = user_data.get("problem_category_key", "")
        reply_markup = get_subcategory_keyboard(category_key)
        await update.message.reply_text(
            TEXTS["messages"]["choose_problem_details"],
            reply_markup=reply_markup,
            parse_mode="HTML",
        )
        return
    
    if text == TEXTS["buttons"]["back_to_problem_choice"]:
        user_data["stage"] = "main_menu"
        reply_markup = get_main_menu_keyboard()
        await update.message.reply_text(
            TEXTS["messages"]["back_to_main_menu"].format(address=user_data.get('machine_address')),
            reply_markup=reply_markup,
            parse_mode="HTML",
        )
        return

    # Сохранение описания
    if text == TEXTS["buttons"]["skip"]:
        user_data["problem_description"] = ""
    else:
        user_data["problem_description"] = text

    user_data["stage"] = "contact"
    keyboard = [
        [KeyboardButton(TEXTS["buttons"]["send_phone"], request_contact=True)],
        [TEXTS["buttons"]["back"]],
    ]
    reply_markup = ReplyKeyboardMarkup(keyboard, resize_keyboard=True)
    
    await update.message.reply_text(
        TEXTS["messages"]["description_saved"],
        reply_markup=reply_markup,
        parse_mode="HTML",
    )

async def handle_contact_stage(update: Update, context: CallbackContext, text: str):
    """Обработка этапа получения контактных данных"""
    user_data = context.user_data
    
    if text == TEXTS["buttons"]["back"]:
        context.user_data["stage"] = "description"
        
        # Определяем уровень навигации для корректного возврата
        if "problem_level3_text" in user_data:
            navigation_level = "level3"
            prompt = TEXTS["messages"]["level3_chosen"].format(level3_problem=user_data.get('problem_level3_text'))
        elif "problem_subcategory_text" in user_data:
            navigation_level = "subcategory"
            prompt = TEXTS["messages"]["subcategory_chosen"].format(subcategory=user_data.get('problem_subcategory_text'))
        else:
            navigation_level = "main"
            prompt = TEXTS["messages"]["problem_chosen"].format(problem=user_data.get('problem_category_text'))

        reply_markup = get_description_keyboard(navigation_level)
        await update.message.reply_text(
            prompt,
            reply_markup=reply_markup,
            parse_mode="HTML",
        )
    else:
        await update.message.reply_text(
            TEXTS["messages"]["request_phone_button"].format(phone=EMERGENCY_PHONE),
            parse_mode="HTML"
        )

# --- COMMAND HANDLERS ---

@log_user_action("start_command")
async def start_command(update: Update, context: CallbackContext):
    """Обработчик команды /start"""
    user = update.effective_user
    logger.info("🚀 Пользователь запустил бота")
    
    # Очистка данных пользователя
    context.user_data.clear()
    
    # Проверка на админские команды
    if context.args:
        arg = context.args[0].lower()
        if arg == "admin" and is_admin(user.id):
            context.user_data["stage"] = "admin_menu"
            reply_markup = get_admin_keyboard()
            await update.message.reply_text(
                TEXTS["admin"]["panel_title"],
                reply_markup=reply_markup,
                parse_mode="HTML"
            )
            return
        
        # Обработка кода автомата из QR
        machine_code = context.args[0]
        machine = await get_machine_by_code(machine_code)
        
        if machine:
            # Сохраняем данные автомата
            context.user_data["machine_id"] = machine["id"]
            context.user_data["machine_code"] = machine["code"]
            context.user_data["machine_address"] = f"{machine['region']}, вул. {machine['street']}, {machine['building_number']}"
            context.user_data["owner_id"] = machine.get("owner_id")
            context.user_data["stage"] = "main_menu"
            
            # Показываем главное меню
            reply_markup = get_main_menu_keyboard()
            await update.message.reply_text(
                TEXTS["messages"]["welcome"].format(address=context.user_data["machine_address"]),
                reply_markup=reply_markup,
                parse_mode="HTML"
            )
        else:
            await update.message.reply_text(
                TEXTS["messages"]["machine_not_found"].format(code=machine_code, phone=EMERGENCY_PHONE),
                parse_mode="HTML"
            )
    else:
        # Запуск без кода автомата
        await update.message.reply_text(
            TEXTS["messages"]["start_without_code"].format(phone=EMERGENCY_PHONE),
            parse_mode="HTML"
        )

@log_user_action("contact_received")
async def contact_received(update: Update, context: CallbackContext):
    """Обработчик получения контактных данных с поддержкой трехуровневой структуры"""
    user_data = context.user_data
    contact = update.message.contact
    
    if contact and contact.user_id == update.effective_user.id:
        # Сохраняем данные пользователя
        user_data["user_id"] = update.effective_user.id
        user_data["user_name"] = update.effective_user.full_name
        user_data["user_phone"] = contact.phone_number
        
        # Создаем заявку с использованием новой функции
        ticket_number = await create_support_ticket_v3(user_data)
        
        if ticket_number:
            # Формируем данные для уведомлений
            problem_full_text = build_problem_chain(user_data)
            
            ticket_data = {
                "ticket_number": ticket_number,
                "machine_address": user_data["machine_address"],
                "machine_code": user_data["machine_code"],
                "problem_full_text": problem_full_text,
                "problem_description": user_data.get("problem_description", ""),
                "user_name": user_data["user_name"],
                "user_phone": user_data["user_phone"]
            }
            
            # Отправляем уведомления владельцу
            if user_data.get("owner_id"):
                owner = await get_owner_by_id(user_data["owner_id"])
                if owner:
                    await send_email_notification(owner, ticket_data)
                    await send_telegram_notification(owner, ticket_data, context)
            
            # Отправляем подтверждение клиенту
            await update.message.reply_text(
                TEXTS["messages"]["ticket_created"].format(
                    ticket_number=ticket_number,
                    address=user_data["machine_address"],
                    problem_full_text=problem_full_text,
                    user_name=user_data["user_name"],
                    phone_number=user_data["user_phone"],
                    current_time=datetime.now().strftime("%d.%m.%Y %H:%M")
                ),
                reply_markup=ReplyKeyboardRemove(),
                parse_mode="HTML"
            )
            
            logger.info(f"🎉 Заявка {ticket_number} успешно создана и отправлена")
            logger.info(f"📋 Полная проблема: {problem_full_text}")
            
        else:
            await update.message.reply_text(
                TEXTS["messages"]["ticket_creation_error"].format(phone=EMERGENCY_PHONE),
                reply_markup=ReplyKeyboardRemove(),
                parse_mode="HTML"
            )
        
        # Очищаем данные пользователя
        context.user_data.clear()

@log_user_action("message_received")
async def handle_message(update: Update, context: CallbackContext):
    """Основной обработчик сообщений с поддержкой трехуровневой навигации"""
    text = update.message.text
    user_id = update.effective_user.id
    
    logger.info(f"💬 Получено сообщение: {text[:50]}{'...' if len(text) > 50 else ''}")

    user_data = context.user_data
    stage = user_data.get("stage", "")

    # Логирование навигации для отладки
    log_navigation_state(user_data, stage)

    # Обработка админских функций
    if stage == "admin_menu" and is_admin(user_id):
        await handle_admin_menu(update, context, text)
        return
    elif stage.startswith("admin_") and is_admin(user_id):
        await handle_admin_actions(update, context, text)
        return

    # Проверка наличия машины
    if not user_data.get("machine_id") and stage != "admin_menu":
        await update.message.reply_text(
            "❌ <b>Для роботи з ботом спочатку відскануйте QR-код на автоматі.</b>\n\n"
            f"📞 <b>Служба підтримки:</b> {EMERGENCY_PHONE}",
            parse_mode="HTML",
        )
        return

    # Маршрутизация по стадиям
    if stage == "main_menu":
        await handle_main_menu(update, context, text)
    elif stage == "subcategory":
        await handle_subcategory_selection(update, context, text)
    elif stage == "level3":  # Новая стадия для 3-го уровня
        await handle_level3_selection(update, context, text)
    elif stage == "description":
        await handle_description_stage(update, context, text)
    elif stage == "contact":
        await handle_contact_stage(update, context, text)
    elif stage == "water_quality":
        await handle_water_quality_menu(update, context, text)
    else:
        # По умолчанию возвращаемся в главное меню
        clean_user_navigation_data(user_data)
        context.user_data["stage"] = "main_menu"
        reply_markup = get_main_menu_keyboard()
        await update.message.reply_text(
            TEXTS["messages"]["back_to_main_menu"].format(address=user_data.get('machine_address', 'Невідомий')),
            reply_markup=reply_markup,
            parse_mode="HTML",
        )

# --- ADMIN FUNCTIONS ---

@admin_required
async def handle_admin_menu(update: Update, context: CallbackContext, text: str):
    """Обработка админского меню"""
    if text == "👥 Список власників":
        context.user_data["stage"] = "admin_list_owners"
        await show_owners_list(update, context)
    elif text == "➕ Додати власника":
        context.user_data["stage"] = "admin_add_owner_name"
        await update.message.reply_text(
            "👤 <b>Додавання нового власника</b>\n\n"
            "Введіть ПІБ власника:",
            parse_mode="HTML"
        )
    elif text == "❌ Видалити власника":
        context.user_data["stage"] = "admin_delete_owner"
        await show_owners_for_deletion(update, context)
    elif text == "📊 Статистика":
        await show_statistics(update, context)
    elif text == "🔙 Назад":
        context.user_data.clear()
        await update.message.reply_text(
            "👋 <b>Вихід з панелі адміністратора</b>",
            reply_markup=ReplyKeyboardRemove(),
            parse_mode="HTML"
        )

async def handle_admin_actions(update: Update, context: CallbackContext, text: str):
    """Обработка админских действий"""
    stage = context.user_data.get("stage", "")
    
    if stage == "admin_add_owner_name":
        context.user_data["new_owner_name"] = text
        context.user_data["stage"] = "admin_add_owner_phone"
        await update.message.reply_text(
            "📞 <b>Введіть номер телефону власника:</b>",
            parse_mode="HTML"
        )
    elif stage == "admin_add_owner_phone":
        context.user_data["new_owner_phone"] = text
        context.user_data["stage"] = "admin_add_owner_email"
        await update.message.reply_text(
            "📧 <b>Введіть email власника:</b>",
            parse_mode="HTML"
        )
    elif stage == "admin_add_owner_email":
        await finish_adding_owner(update, context, text)

async def show_owners_list(update: Update, context: CallbackContext):
    """Показать список владельцев"""
    try:
        response = supabase.table("owners").select("*").execute()
        
        if response.data:
            message = "👥 <b>СПИСОК ВЛАСНИКІВ</b>\n\n"
            for owner in response.data:
                message += f"🆔 <b>ID:</b> {owner['owner_id']}\n"
                message += f"👤 <b>ПІБ:</b> {owner.get('first_name', '')} {owner.get('last_name', '')}\n"
                message += f"📞 <b>Телефон:</b> {owner.get('mobile_phone', 'Не указан')}\n"
                message += f"📧 <b>Email:</b> {owner.get('email', 'Не указан')}\n"
                message += "─────────────────\n"
        else:
            message = "ℹ️ <b>Список власників порожній</b>"
        
        await update.message.reply_text(message, parse_mode="HTML")
        
    except Exception as e:
        logger.error(f"❌ Ошибка получения списка владельцев: {e}")
        await update.message.reply_text(
            "❌ <b>Помилка отримання даних</b>",
            parse_mode="HTML"
        )

async def show_owners_for_deletion(update: Update, context: CallbackContext):
    """Показать владельцев для удаления"""
    try:
        response = supabase.table("owners").select("owner_id, first_name, last_name").execute()
        
        if response.data:
            keyboard = []
            for owner in response.data:
                name = f"{owner.get('first_name', '')} {owner.get('last_name', '')}"
                keyboard.append([f"🗑️ {owner['owner_id']} - {name}"])
            
            keyboard.append(["🔙 Назад"])
            reply_markup = ReplyKeyboardMarkup(keyboard, resize_keyboard=True)
            
            await update.message.reply_text(
                "❌ <b>Оберіть власника для видалення:</b>",
                reply_markup=reply_markup,
                parse_mode="HTML"
            )
        else:
            await update.message.reply_text("ℹ️ <b>Немає власників для видалення</b>", parse_mode="HTML")
        
    except Exception as e:
        logger.error(f"❌ Ошибка получения владельцев: {e}")

async def finish_adding_owner(update: Update, context: CallbackContext, email: str):
    """Завершение добавления владельца"""
    if not validate_email(email):
        await update.message.reply_text(
            "❌ <b>Невірний формат email</b>\n\nВведіть правильний email:",
            parse_mode="HTML"
        )
        return
    
    try:
        owner_data = {
            "first_name": context.user_data["new_owner_name"].split()[0],
            "last_name": " ".join(context.user_data["new_owner_name"].split()[1:]),
            "mobile_phone": context.user_data["new_owner_phone"],
            "email": email,
            "ownership_form": "ФОП"
        }
        
        response = supabase.table("owners").insert(owner_data).execute()
        
        if response.data:
            await update.message.reply_text(
                f"✅ <b>Власник успішно доданий!</b>\n\n"
                f"👤 <b>ПІБ:</b> {context.user_data['new_owner_name']}\n"
                f"📞 <b>Телефон:</b> {context.user_data['new_owner_phone']}\n"
                f"📧 <b>Email:</b> {email}",
                reply_markup=get_admin_keyboard(),
                parse_mode="HTML"
            )
        else:
            await update.message.reply_text(
                "❌ <b>Помилка додавання власника</b>",
                reply_markup=get_admin_keyboard(),
                parse_mode="HTML"
            )
        
        context.user_data["stage"] = "admin_menu"
        
    except Exception as e:
        logger.error(f"❌ Ошибка добавления владельца: {e}")
        await update.message.reply_text(
            "❌ <b>Помилка бази даних</b>",
            reply_markup=get_admin_keyboard(),
            parse_mode="HTML"
        )

async def show_statistics(update: Update, context: CallbackContext):
    """Показать статистику системы"""
    try:
        # Статистика заявок
        tickets_response = supabase.table("support_tickets").select("status").execute()
        machines_response = supabase.table("machines").select("*").execute()
        owners_response = supabase.table("owners").select("*").execute()
        
        tickets_count = len(tickets_response.data) if tickets_response.data else 0
        machines_count = len(machines_response.data) if machines_response.data else 0
        owners_count = len(owners_response.data) if owners_response.data else 0
        
        # Статистика по статусам заявок
        new_tickets = len([t for t in tickets_response.data if t['status'] == 'new']) if tickets_response.data else 0
        in_progress = len([t for t in tickets_response.data if t['status'] == 'in_progress']) if tickets_response.data else 0
        resolved = len([t for t in tickets_response.data if t['status'] == 'resolved']) if tickets_response.data else 0
        
        message = f"""
📊 <b>СТАТИСТИКА СИСТЕМИ</b>

📋 <b>Заявки:</b>
• Всього: {tickets_count}
• Нові: {new_tickets}
• В роботі: {in_progress}
• Вирішені: {resolved}

🏪 <b>Автомати:</b> {machines_count}
👥 <b>Власники:</b> {owners_count}

📅 <b>Дата оновлення:</b> {datetime.now().strftime('%d.%m.%Y %H:%M')}
        """
        
        await update.message.reply_text(message, parse_mode="HTML")
        
    except Exception as e:
        logger.error(f"❌ Ошибка получения статистики: {e}")
        await update.message.reply_text(
            "❌ <b>Помилка отримання статистики</b>",
            parse_mode="HTML"
        )

# --- ERROR HANDLERS ---

async def error_handler(update: object, context: CallbackContext):
    """Обработчик ошибок"""
    logger.error(f"❌ Произошла ошибка: {context.error}")
    
    if isinstance(update, Update) and update.message:
        await update.message.reply_text(
            f"❌ <b>Виникла помилка</b>\n\n"
            f"Будь ласка, спробуйте ще раз або зверніться до служби підтримки:\n"
            f"📞 {EMERGENCY_PHONE}",
            parse_mode="HTML"
        )

# --- MAIN FUNCTION ---

def main():
    """Основная функция запуска бота"""
    global supabase
    
    # Запуск системы предпроверок
    if not PreStartupSystem.run_all_checks():
        logger.critical("🚫 Бот не может быть запущен из-за неуспешных проверок")
        return
    
    # Инициализация Supabase
    try:
        supabase = create_client(SUPABASE_URL, SUPABASE_KEY)
        logger.info("✅ Supabase клиент инициализирован")
    except Exception as e:
        logger.critical(f"❌ Ошибка инициализации Supabase: {e}")
        return
    
    # Информация о системе
    logger.info("\n🎯 СИСТЕМА ГОТОВА К РАБОТЕ!")
    logger.info("🎉 НОВЫЕ ВОЗМОЖНОСТИ V4.3:")
    logger.info("   ✅ Трехуровневая навигация (60+ конкретных проблем)")
    logger.info("   ✅ Двухколоночное меню с эмодзи")
    logger.info("   ✅ Расширенная фискализация платежей")
    logger.info("   ✅ Экстренные ситуации с детализацией")
    logger.info("   ✅ Полная проверка SMTP связи")
    logger.info("   ✅ Административные функции")
    logger.info("   ✅ Email и Telegram уведомления владельцам")
    logger.info(f"   ✅ Настроены администраторы: {ADMIN_USER_IDS}")
    logger.info("   📋 Админские команды: /start admin")
    
    # Запуск мониторинга
    logger.info("📊 Запуск мониторинга системы...")
    start_monitoring()
    
    # Создание приложения
    application = Application.builder().token(TOKEN).build()
    
    # Регистрация обработчиков
    application.add_handler(CommandHandler("start", start_command))
    application.add_handler(MessageHandler(filters.CONTACT, contact_received))
    application.add_handler(MessageHandler(filters.TEXT & ~filters.COMMAND, handle_message))
    
    # Обработчик ошибок
    application.add_error_handler(error_handler)
    
    logger.info("🤖 Бот запущен и готов к работе!")
    logger.info("=" * 70)
    
    # Запуск бота
    application.run_polling(allowed_updates=Update.ALL_TYPES)

if __name__ == "__main__":
    main()