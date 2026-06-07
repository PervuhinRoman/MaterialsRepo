# Скрипт заполнения БД тестовыми данными
# Запуск: python seed.py
import asyncio
import os
import uuid

from sqlalchemy.ext.asyncio import create_async_engine, async_sessionmaker, AsyncSession

from app.db import registry  # noqa: F401
from app.modules.auth.models import User, Role
from app.modules.materials.models import Category, Material
from app.core.security import hash_password
from app.core.config import get_settings

settings = get_settings()

# KISS: seed всегда запускается локально — берём localhost-URL
_DB_URL = settings.database_url_local or settings.database_url

_engine = create_async_engine(_DB_URL, echo=False)
_SessionLocal = async_sessionmaker(bind=_engine, expire_on_commit=False, class_=AsyncSession)


async def seed():
    async with _SessionLocal() as session:
        await _seed_users(session)
        await _seed_categories(session)
        await _seed_materials(session)
    await _engine.dispose()
    print("Seed завершён.")


async def _seed_users(session: AsyncSession):
    users = [
        User(
            id=uuid.UUID("00000000-0000-0000-0000-000000000001"),
            email="admin@edu.ru",
            username="admin",
            hashed_password=hash_password("admin123"),
            role=Role.ADMIN,
        ),
        User(
            id=uuid.UUID("00000000-0000-0000-0000-000000000002"),
            email="teacher@edu.ru",
            username="teacher",
            hashed_password=hash_password("teacher123"),
            role=Role.TEACHER,
        ),
        User(
            id=uuid.UUID("00000000-0000-0000-0000-000000000003"),
            email="student@edu.ru",
            username="student",
            hashed_password=hash_password("student123"),
            role=Role.STUDENT,
        ),
    ]
    for user in users:
        existing = await session.get(User, user.id)
        if not existing:
            session.add(user)
    await session.commit()
    print(f"  Пользователи: {len(users)} записей")


async def _seed_categories(session: AsyncSession):
    categories = [
        Category(
            id=uuid.UUID("10000000-0000-0000-0000-000000000001"),
            name="Математика",
            description="Математические дисциплины",
        ),
        Category(
            id=uuid.UUID("10000000-0000-0000-0000-000000000002"),
            name="Программирование",
            description="Языки и технологии разработки",
        ),
        Category(
            id=uuid.UUID("10000000-0000-0000-0000-000000000003"),
            name="Базы данных",
            description="СУБД и проектирование БД",
            parent_id=uuid.UUID("10000000-0000-0000-0000-000000000002"),
        ),
    ]
    for cat in categories:
        existing = await session.get(Category, cat.id)
        if not existing:
            session.add(cat)
    await session.commit()
    print(f"  Категории: {len(categories)} записей")


async def _seed_materials(session: AsyncSession):
    upload_dir = "uploads/seed"
    os.makedirs(upload_dir, exist_ok=True)

    files = [
        ("lecture_01.txt", "Лекция 1. Введение в алгоритмы",
         "10000000-0000-0000-0000-000000000001"),
        ("lecture_02.txt", "Лекция 2. Реляционные СУБД",
         "10000000-0000-0000-0000-000000000003"),
    ]

    materials = []
    for filename, title, cat_id in files:
        path = os.path.join(upload_dir, filename)
        if not os.path.exists(path):
            with open(path, "w") as f:
                f.write(f"Содержимое: {title}")
        materials.append(Material(
            id=uuid.uuid4(),
            title=title,
            file_path=path,
            file_name=filename,
            file_size=os.path.getsize(path),
            mime_type="text/plain",
            author_id=uuid.UUID("00000000-0000-0000-0000-000000000002"),
            category_id=uuid.UUID(cat_id),
        ))

    for mat in materials:
        session.add(mat)
    await session.commit()
    print(f"  Материалы: {len(materials)} записей")


if __name__ == "__main__":
    asyncio.run(seed())