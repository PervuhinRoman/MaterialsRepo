# SRP: модуль materials отвечает только за учебные материалы и категории
from sqlalchemy import Column, String, Text, Integer, ForeignKey, DateTime, func
from sqlalchemy.orm import relationship
from sqlalchemy.dialects.postgresql import UUID
from app.db.base import Base


class Category(Base):
    __tablename__ = "categories"

    # KISS: простая иерархия — одна таблица, self-referential FK
    name = Column(String(200), nullable=False)
    description = Column(Text, nullable=True)
    parent_id = Column(UUID(as_uuid=True), ForeignKey("categories.id"), nullable=True)

    parent = relationship("Category", remote_side="Category.id", back_populates="children")
    children = relationship("Category", back_populates="parent")
    materials = relationship("Material", back_populates="category")


class Material(Base):
    __tablename__ = "materials"

    title = Column(String(300), nullable=False)
    description = Column(Text, nullable=True)
    file_path = Column(String(500), nullable=False)   # путь к файлу на диске
    file_name = Column(String(255), nullable=False)   # оригинальное имя файла
    file_size = Column(Integer, nullable=False)        # байты
    mime_type = Column(String(100), nullable=False)
    download_count = Column(Integer, default=0, nullable=False)

    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    # DIP: связь через FK, не через прямой импорт объекта User
    author_id = Column(UUID(as_uuid=True), ForeignKey("users.id"), nullable=False)
    category_id = Column(UUID(as_uuid=True), ForeignKey("categories.id"), nullable=True)

    author = relationship("User", back_populates="materials")
    category = relationship("Category", back_populates="materials")
    access_logs = relationship("AccessLog", back_populates="material")

    @property
    def author_username(self):
        return self.author.username if self.author else None

    @property
    def author_email(self):
        return self.author.email if self.author else None