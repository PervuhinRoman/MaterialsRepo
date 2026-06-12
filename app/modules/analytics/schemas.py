# KISS: простые схемы только для вывода — логи не создаются вручную через API
from pydantic import BaseModel
from uuid import UUID
from datetime import datetime
from typing import Optional


class LogOut(BaseModel):
    id: UUID
    action: str
    ip_address: Optional[str]
    user_id: Optional[UUID]
    material_id: Optional[UUID]
    created_at: datetime

    model_config = {"from_attributes": True}


class MaterialStatsOut(BaseModel):
    material_id: str
    total: int
    views: int
    downloads: int


class SummaryOut(BaseModel):
    total_events: int
    views: int
    downloads: int
    uploads: int


class TopMaterialOut(BaseModel):
    material_id: Optional[UUID]
    title: Optional[str]
    count: int