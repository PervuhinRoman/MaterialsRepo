# ISP: разделены схемы создания, обновления и вывода
from pydantic import BaseModel
from uuid import UUID
from datetime import datetime
from typing import Optional


class CategoryCreate(BaseModel):
    name: str
    description: Optional[str] = None
    parent_id: Optional[UUID] = None


class CategoryOut(BaseModel):
    id: UUID
    name: str
    description: Optional[str]
    parent_id: Optional[UUID]

    model_config = {"from_attributes": True}


class MaterialCreate(BaseModel):
    title: str
    description: Optional[str] = None
    category_id: Optional[UUID] = None


class MaterialUpdate(BaseModel):
    title: Optional[str] = None
    description: Optional[str] = None
    category_id: Optional[UUID] = None


class MaterialOut(BaseModel):
    id: UUID
    title: str
    description: Optional[str]
    file_name: str
    file_size: int
    mime_type: str
    download_count: int
    author_id: UUID
    category_id: Optional[UUID]
    created_at: datetime
    updated_at: Optional[datetime]

    model_config = {"from_attributes": True}