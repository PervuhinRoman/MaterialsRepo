# DRY: общие фикстуры для всех тестов
import pytest
import pytest_asyncio
from httpx import AsyncClient, ASGITransport
from sqlalchemy.ext.asyncio import create_async_engine, async_sessionmaker, AsyncSession
from sqlalchemy import update

from app.main import app
from app.db.base import Base
from app.db.session import get_db
from app.db import registry  # noqa: F401
from app.modules.auth.models import User, Role

TEST_DATABASE_URL = "sqlite+aiosqlite:///:memory:"


@pytest_asyncio.fixture(scope="session")
async def test_engine():
    engine = create_async_engine(TEST_DATABASE_URL, echo=False)
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)
    yield engine
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.drop_all)
    await engine.dispose()


@pytest_asyncio.fixture
async def test_session(test_engine):
    session_factory = async_sessionmaker(
        bind=test_engine, expire_on_commit=False, class_=AsyncSession
    )
    async with session_factory() as session:
        yield session


@pytest_asyncio.fixture
async def client(test_session):
    async def override_get_db():
        yield test_session

    app.dependency_overrides[get_db] = override_get_db
    async with AsyncClient(
        transport=ASGITransport(app=app), base_url="http://test"
    ) as ac:
        yield ac
    app.dependency_overrides.clear()


@pytest_asyncio.fixture
async def student_headers(client):
    # DRY: создание студента и получение токена в одной фикстуре
    await client.post("/auth/register", json={
        "email": "student@edu.ru",
        "username": "student",
        "password": "student123",
    })
    resp = await client.post("/auth/login", data={
        "username": "student@edu.ru",
        "password": "student123",
    })
    return {"Authorization": f"Bearer {resp.json()['access_token']}"}


@pytest_asyncio.fixture
async def teacher_headers(client, test_session):
    # Регистрируем и повышаем до teacher напрямую в тестовой БД
    await client.post("/auth/register", json={
        "email": "teacher@edu.ru",
        "username": "teacher",
        "password": "teacher123",
    })
    await test_session.execute(
        update(User).where(User.email == "teacher@edu.ru").values(role=Role.TEACHER)
    )
    await test_session.commit()
    resp = await client.post("/auth/login", data={
        "username": "teacher@edu.ru",
        "password": "teacher123",
    })
    return {"Authorization": f"Bearer {resp.json()['access_token']}"}


@pytest_asyncio.fixture
async def admin_headers(client, test_session):
    await client.post("/auth/register", json={
        "email": "admin@edu.ru",
        "username": "admin",
        "password": "admin123",
    })
    await test_session.execute(
        update(User).where(User.email == "admin@edu.ru").values(role=Role.ADMIN)
    )
    await test_session.commit()
    resp = await client.post("/auth/login", data={
        "username": "admin@edu.ru",
        "password": "admin123",
    })
    return {"Authorization": f"Bearer {resp.json()['access_token']}"}