# SRP: только HTTP-обёртка над AuthService
# DIP: сервис получается через Depends, не создаётся здесь
from fastapi import APIRouter, Depends
from fastapi.security import OAuth2PasswordRequestForm
from sqlalchemy.ext.asyncio import AsyncSession

from app.db.session import get_db
from app.core.dependencies import get_current_user, require_role
from app.modules.auth.repository import UserRepository
from app.modules.auth.service import AuthService
from app.modules.auth.schemas import UserRegister, UserOut, TokenOut, UserSetActive
from app.modules.auth.models import User, Role

router = APIRouter(prefix="/auth", tags=["auth"])


def get_auth_service(session: AsyncSession = Depends(get_db)) -> AuthService:
    # DIP: сборка зависимостей в одном месте
    return AuthService(UserRepository(session))


@router.post("/register", response_model=UserOut, status_code=201)
async def register(
    data: UserRegister,
    service: AuthService = Depends(get_auth_service),
):
    return await service.register(
        email=data.email,
        username=data.username,
        password=data.password,
        role=data.role,
    )


@router.post("/login", response_model=TokenOut)
async def login(
    form: OAuth2PasswordRequestForm = Depends(),
    service: AuthService = Depends(get_auth_service),
):
    # OAuth2PasswordRequestForm использует поля username/password
    # передаём username как email (стандартная практика для JWT-сервисов)
    return await service.login(email=form.username, password=form.password)


@router.get("/me", response_model=UserOut)
async def me(current_user: User = Depends(get_current_user)):
    return current_user


@router.get("/users", response_model=list[UserOut])
async def list_users(
    service: AuthService = Depends(get_auth_service),
    _: User = Depends(require_role(Role.ADMIN)),
):
    return await service.list_users()


@router.patch("/users/{user_id}", response_model=UserOut)
async def set_user_active(
    user_id: str,
    body: UserSetActive,
    service: AuthService = Depends(get_auth_service),
    _: User = Depends(require_role(Role.ADMIN)),
):
    from uuid import UUID
    user = await service.set_active(UUID(user_id), body.is_active)
    if user is None:
        from fastapi import HTTPException, status
        raise HTTPException(status.HTTP_404_NOT_FOUND, detail="Пользователь не найден")
    return user