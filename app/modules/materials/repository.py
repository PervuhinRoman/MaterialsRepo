# SRP: только SQL-запросы к таблицам materials и categories
from typing import List, Optional
from uuid import UUID
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.repository import AbstractRepository
from app.modules.materials.models import Material, Category


class MaterialRepository(AbstractRepository[Material]):

    def __init__(self, session: AsyncSession):
        self._session = session

    async def get(self, id: UUID) -> Optional[Material]:
        result = await self._session.execute(
            select(Material).where(Material.id == id)
        )
        return result.scalar_one_or_none()

    async def get_all(self, skip: int = 0, limit: int = 100) -> List[Material]:
        result = await self._session.execute(
            select(Material).offset(skip).limit(limit)
        )
        return list(result.scalars().all())

    async def get_by_category(self, category_id: UUID) -> List[Material]:
        result = await self._session.execute(
            select(Material).where(Material.category_id == category_id)
        )
        return list(result.scalars().all())

    async def create(self, **kwargs) -> Material:
        material = Material(**kwargs)
        self._session.add(material)
        await self._session.commit()
        await self._session.refresh(material)
        return material

    async def update(self, id: UUID, **kwargs) -> Optional[Material]:
        material = await self.get(id)
        if not material:
            return None
        for key, value in kwargs.items():
            setattr(material, key, value)
        await self._session.commit()
        await self._session.refresh(material)
        return material

    async def delete(self, id: UUID) -> bool:
        material = await self.get(id)
        if not material:
            return False
        await self._session.delete(material)
        await self._session.commit()
        return True

    async def increment_downloads(self, id: UUID) -> None:
        # DRY: атомарное обновление счётчика в одном месте
        material = await self.get(id)
        if material:
            material.download_count += 1
            await self._session.commit()


class CategoryRepository(AbstractRepository[Category]):

    def __init__(self, session: AsyncSession):
        self._session = session

    async def get(self, id: UUID) -> Optional[Category]:
        result = await self._session.execute(
            select(Category).where(Category.id == id)
        )
        return result.scalar_one_or_none()

    async def get_all(self, skip: int = 0, limit: int = 100) -> List[Category]:
        result = await self._session.execute(
            select(Category).offset(skip).limit(limit)
        )
        return list(result.scalars().all())

    async def create(self, **kwargs) -> Category:
        category = Category(**kwargs)
        self._session.add(category)
        await self._session.commit()
        await self._session.refresh(category)
        return category

    async def update(self, id: UUID, **kwargs) -> Optional[Category]:
        category = await self.get(id)
        if not category:
            return None
        for key, value in kwargs.items():
            setattr(category, key, value)
        await self._session.commit()
        await self._session.refresh(category)
        return category

    async def delete(self, id: UUID) -> bool:
        category = await self.get(id)
        if not category:
            return False
        await self._session.delete(category)
        await self._session.commit()
        return True