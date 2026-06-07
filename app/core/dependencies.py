# DIP: провайдеры зависимостей — роутеры не создают объекты напрямую
from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from sqlalchemy.ext.asyncio import AsyncSession
from jose import JWTError
from uuid import UUID

from app.db.session import get_db
from app.core.security import decode_access_token
from app.modules.auth.repository import UserRepository
from app.modules.auth.models import User, Role

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/auth/login")


async def get_current_user(
    token: str = Depends(oauth2_scheme),
    session: AsyncSession = Depends(get_db),
) -> User:
    credentials_exc = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Не удалось проверить учётные данные",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = decode_access_token(token)
        user_id: str = payload.get("sub")
        if user_id is None:
            raise credentials_exc
    except JWTError:
        raise credentials_exc

    user = await UserRepository(session).get(UUID(user_id))
    if user is None or not user.is_active:
        raise credentials_exc
    return user


def require_role(*roles: Role):
    # OCP: новые роли добавляются без изменения этой функции
    async def checker(current_user: User = Depends(get_current_user)) -> User:
        if current_user.role not in roles:
            raise HTTPException(status.HTTP_403_FORBIDDEN,
                                detail="Недостаточно прав")
        return current_user
    return checker