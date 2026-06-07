# SRP: единственная ответственность — конфигурация приложения
# DIP: остальные модули зависят от этого контракта, не от os.environ напрямую
from pydantic_settings import BaseSettings, SettingsConfigDict
from functools import lru_cache


class Settings(BaseSettings):
    # БД
    database_url: str
    database_url_local: str | None = None  # для Alembic с локальной машины
    postgres_user: str
    postgres_password: str
    postgres_db: str
    postgres_host: str = "db"
    postgres_port: int = 5432

    # JWT
    secret_key: str
    algorithm: str = "HS256"
    access_token_expire_minutes: int = 30

    # Файлы
    upload_dir: str = "uploads"
    max_file_size_mb: int = 50

    model_config = SettingsConfigDict(env_file=".env", case_sensitive=False)


@lru_cache  # KISS: единственный экземпляр настроек на всё приложение
def get_settings() -> Settings:
    return Settings()