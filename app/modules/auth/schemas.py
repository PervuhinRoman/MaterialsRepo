# ISP: отдельные схемы для входа и выхода — клиент получает только нужные поля
from typing import Literal
from pydantic import BaseModel, EmailStr
from uuid import UUID
from datetime import datetime
from app.modules.auth.models import Role

# OCP: допустимые для самостоятельной регистрации роли — не admin
RegistrationRole = Literal[Role.STUDENT, Role.TEACHER]


class UserRegister(BaseModel):
    email: EmailStr
    username: str
    password: str
    role: RegistrationRole = Role.STUDENT


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