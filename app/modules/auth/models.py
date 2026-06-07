# SRP: модуль auth отвечает только за пользователей и роли
from sqlalchemy import Column, String, Enum, Boolean, DateTime, func
from sqlalchemy.orm import relationship
from app.db.base import Base
import enum


class Role(str, enum.Enum):
    # OCP: новые роли добавляются без изменения логики проверки
    STUDENT = "student"
    TEACHER = "teacher"
    ADMIN = "admin"


class User(Base):
    __tablename__ = "users"

    email = Column(String(255), unique=True, nullable=False, index=True)
    username = Column(String(100), unique=True, nullable=False)
    hashed_password = Column(String(255), nullable=False)
    role = Column(Enum(Role), nullable=False, default=Role.STUDENT)
    is_active = Column(Boolean, default=True, nullable=False)

    # DRY: временные метки вынесены сюда, не дублируются в других моделях
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    # Связи (ISP: каждый модуль видит только нужные ему поля)
    materials = relationship("Material", back_populates="author", lazy="selectin")
    access_logs = relationship("AccessLog", back_populates="user", lazy="selectin")