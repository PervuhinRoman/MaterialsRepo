# SRP: только SQL-запросы к таблице access_logs
from typing import List, Optional
from uuid import UUID
from sqlalchemy import select, func
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.repository import AbstractRepository
from app.modules.analytics.models import AccessLog


class LogRepository(AbstractRepository[AccessLog]):

    def __init__(self, session: AsyncSession):
        self._session = session

    async def get(self, id: UUID) -> Optional[AccessLog]:
        result = await self._session.execute(
            select(AccessLog).where(AccessLog.id == id)
        )
        return result.scalar_one_or_none()

    async def get_all(self, skip: int = 0, limit: int = 100) -> List[AccessLog]:
        result = await self._session.execute(
            select(AccessLog).offset(skip).limit(limit)
        )
        return list(result.scalars().all())

    async def get_by_material(self, material_id: UUID) -> List[AccessLog]:
        result = await self._session.execute(
            select(AccessLog).where(AccessLog.material_id == material_id)
        )
        return list(result.scalars().all())

    async def create(self, **kwargs) -> AccessLog:
        log = AccessLog(**kwargs)
        self._session.add(log)
        await self._session.commit()
        await self._session.refresh(log)
        return log

    async def update(self, id: UUID, **kwargs) -> Optional[AccessLog]:
        # KISS: логи не редактируются — метод заглушка для соответствия интерфейсу
        return None

    async def delete(self, id: UUID) -> bool:
        log = await self.get(id)
        if not log:
            return False
        await self._session.delete(log)
        await self._session.commit()
        return True

    async def get_top_materials(self, limit: int = 10) -> List[dict]:
        # Агрегация: топ материалов по числу обращений
        result = await self._session.execute(
            select(AccessLog.material_id, func.count(AccessLog.id).label("count"))
            .group_by(AccessLog.material_id)
            .order_by(func.count(AccessLog.id).desc())
            .limit(limit)
        )
        return [{"material_id": row.material_id, "count": row.count}
                for row in result.all()]