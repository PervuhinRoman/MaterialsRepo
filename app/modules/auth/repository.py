# SRP: только SQL-запросы к таблице users
from typing import List, Optional
from uuid import UUID
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.repository import AbstractRepository
from app.modules.auth.models import User


class UserRepository(AbstractRepository[User]):

    def __init__(self, session: AsyncSession):
        self._session = session

    async def get(self, id: UUID) -> Optional[User]:
        result = await self._session.execute(select(User).where(User.id == id))
        return result.scalar_one_or_none()

    async def get_by_email(self, email: str) -> Optional[User]:
        result = await self._session.execute(select(User).where(User.email == email))
        return result.scalar_one_or_none()

    async def get_by_username(self, username: str) -> Optional[User]:
        result = await self._session.execute(
            select(User).where(User.username == username)
        )
        return result.scalar_one_or_none()

    async def get_all(self, skip: int = 0, limit: int = 100) -> List[User]:
        result = await self._session.execute(select(User).offset(skip).limit(limit))
        return list(result.scalars().all())

    async def create(self, **kwargs) -> User:
        user = User(**kwargs)
        self._session.add(user)
        await self._session.commit()
        await self._session.refresh(user)
        return user

    async def update(self, id: UUID, **kwargs) -> Optional[User]:
        user = await self.get(id)
        if not user:
            return None
        for key, value in kwargs.items():
            setattr(user, key, value)
        await self._session.commit()
        await self._session.refresh(user)
        return user

    async def delete(self, id: UUID) -> bool:
        user = await self.get(id)
        if not user:
            return False
        await self._session.delete(user)
        await self._session.commit()
        return True