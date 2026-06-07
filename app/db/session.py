# SRP: единственная ответственность — управление сессиями БД
# DIP: роутеры зависят от абстракции AsyncSession, не от конкретного движка
from sqlalchemy.ext.asyncio import create_async_engine, async_sessionmaker, AsyncSession
from app.core.config import get_settings

settings = get_settings()

engine = create_async_engine(
    settings.database_url,
    echo=False,       # True только при отладке
    pool_size=10,
    max_overflow=20,
)

AsyncSessionLocal = async_sessionmaker(
    bind=engine,
    expire_on_commit=False,
    class_=AsyncSession,
)


async def get_db() -> AsyncSession:
    # DI: провайдер сессии для FastAPI Depends()
    async with AsyncSessionLocal() as session:
        yield session