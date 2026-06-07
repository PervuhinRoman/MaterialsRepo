# OCP: Base — только базовый класс, без импортов моделей
from sqlalchemy.orm import DeclarativeBase
from sqlalchemy import Column
from sqlalchemy.dialects.postgresql import UUID
import uuid


class Base(DeclarativeBase):
    # DRY: общий PK UUID для всех сущностей
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
