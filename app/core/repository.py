# DIP: сервисный слой зависит от этой абстракции, не от SQLAlchemy напрямую
# OCP: новые репозитории расширяют AbstractRepository, не меняя его
from abc import ABC, abstractmethod
from typing import Generic, TypeVar, List, Optional
from uuid import UUID

T = TypeVar("T")


class AbstractRepository(ABC, Generic[T]):

    @abstractmethod
    async def get(self, id: UUID) -> Optional[T]: ...

    @abstractmethod
    async def get_all(self, skip: int = 0, limit: int = 100) -> List[T]: ...

    @abstractmethod
    async def create(self, **kwargs) -> T: ...

    @abstractmethod
    async def update(self, id: UUID, **kwargs) -> Optional[T]: ...

    @abstractmethod
    async def delete(self, id: UUID) -> bool: ...