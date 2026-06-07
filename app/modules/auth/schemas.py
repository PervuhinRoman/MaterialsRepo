# ISP: отдельные схемы для входа и выхода — клиент получает только нужные поля
from pydantic import BaseModel, EmailStr
from uuid import UUID
from datetime import datetime
from app.modules.auth.models import Role


class UserRegister(BaseModel):
    email: EmailStr
    username: str
    password: str


class UserLogin(BaseModel):
    email: EmailStr
    password: str


class UserOut(BaseModel):
    id: UUID
    email: str
    username: str
    role: Role
    is_active: bool
    created_at: datetime

    model_config = {"from_attributes": True}  # ORM -> Pydantic


class TokenOut(BaseModel):
    access_token: str
    token_type: str