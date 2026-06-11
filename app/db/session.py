import os
from sqlalchemy.ext.asyncio import create_async_engine, async_sessionmaker, AsyncSession


def _get_db_url() -> str:
    url = (
        os.environ.get("DATABASE_URL_LOCAL")
        or os.environ.get("DATABASE_URL")
        or ""
    )
    if url.startswith("postgresql://"):
        url = url.replace("postgresql://", "postgresql+asyncpg://", 1)
    return url


engine = create_async_engine(
    _get_db_url(),
    echo=False,
    pool_size=10,
    max_overflow=20,
)

AsyncSessionLocal = async_sessionmaker(
    bind=engine,
    expire_on_commit=False,
    class_=AsyncSession,
)


async def get_db() -> AsyncSession:
    async with AsyncSessionLocal() as session:
        yield session