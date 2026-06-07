# SRP: модуль analytics отвечает только за фиксацию событий доступа
from sqlalchemy import Column, String, ForeignKey, DateTime, func
from sqlalchemy.orm import relationship
from sqlalchemy.dialects.postgresql import UUID
from app.db.base import Base


class AccessLog(Base):
    __tablename__ = "access_logs"

    # KISS: одна запись = одно событие, без сложной агрегации на уровне модели
    action = Column(String(50), nullable=False)   # "view", "download", "upload"
    ip_address = Column(String(45), nullable=True)

    created_at = Column(DateTime(timezone=True), server_default=func.now())

    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id"), nullable=True)
    material_id = Column(UUID(as_uuid=True), ForeignKey("materials.id"), nullable=True)

    user = relationship("User", back_populates="access_logs")
    material = relationship("Material", back_populates="access_logs")