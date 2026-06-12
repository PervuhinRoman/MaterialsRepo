# SRP: только бизнес-логика аутентификации
# DIP: зависит от UserRepository через конструктор, не создаёт его сам
from typing import Optional
from fastapi import HTTPException, status
from app.modules.auth.repository import UserRepository
from app.modules.auth.models import User, Role
from app.core.security import hash_password, verify_password, create_access_token


class AuthService:

    def __init__(self, repo: UserRepository):
        self._repo = repo

    async def register(
        self, email: str, username: str, password: str, role: str = "student"
    ) -> User:
        # KISS: проверки — по одной, с понятными сообщениями
        if await self._repo.get_by_email(email):
            raise HTTPException(status.HTTP_400_BAD_REQUEST,
                                detail="Email уже зарегистрирован")
        if await self._repo.get_by_username(username):
            raise HTTPException(status.HTTP_400_BAD_REQUEST,
                                detail="Имя пользователя занято")
        return await self._repo.create(
            email=email,
            username=username,
            hashed_password=hash_password(password),
            role=role,
        )

    async def login(self, email: str, password: str) -> dict:
        user = await self._repo.get_by_email(email)
        if not user or not verify_password(password, user.hashed_password):
            raise HTTPException(status.HTTP_401_UNAUTHORIZED,
                                detail="Неверный email или пароль")
        if not user.is_active:
            raise HTTPException(status.HTTP_403_FORBIDDEN,
                                detail="Учётная запись деактивирована")
        token = create_access_token({"sub": str(user.id), "role": user.role.value})
        return {"access_token": token, "token_type": "bearer"}

    async def get_by_id(self, user_id) -> Optional[User]:
        return await self._repo.get(user_id)

    async def list_users(self, skip: int = 0, limit: int = 200) -> list[User]:
        users = await self._repo.get_all(skip=skip, limit=limit)
        return [u for u in users if u.role != Role.ADMIN]

    async def set_active(self, user_id, is_active: bool) -> Optional[User]:
        user = await self._repo.get(user_id)
        if user is None:
            return None
        if user.role.value == "admin":
            raise HTTPException(
                status.HTTP_403_FORBIDDEN,
                detail="Нельзя деактивировать администратора",
            )
        return await self._repo.update(user_id, is_active=is_active)