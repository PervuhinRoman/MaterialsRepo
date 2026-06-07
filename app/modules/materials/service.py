# SRP: только бизнес-логика материалов
# DIP: зависит от репозиториев и AnalyticsService через конструктор
import os
import uuid
from fastapi import HTTPException, UploadFile, status
from app.modules.materials.repository import MaterialRepository, CategoryRepository
from app.modules.analytics.service import AnalyticsService
from app.core.config import get_settings

settings = get_settings()


class MaterialsService:

    def __init__(
        self,
        repo: MaterialRepository,
        category_repo: CategoryRepository,
        analytics: AnalyticsService,
    ):
        self._repo = repo
        self._cat_repo = category_repo
        self._analytics = analytics

    async def get_all(self, skip: int = 0, limit: int = 100):
        return await self._repo.get_all(skip=skip, limit=limit)

    async def get_by_id(self, material_id, user_id=None, ip=None):
        material = await self._repo.get(material_id)
        if not material:
            raise HTTPException(status.HTTP_404_NOT_FOUND, detail="Материал не найден")
        # вызов analytics (межмодульное взаимодействие)
        await self._analytics.log_event("view", material_id, user_id, ip)
        return material

    async def upload(self, file: UploadFile, title: str, description: str,
                     author_id, category_id=None):
        # KISS: список разрешённых MIME-типов в одном месте
        ALLOWED_MIME_TYPES = {
            "application/pdf",
            "application/msword",
            "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
            "application/vnd.ms-powerpoint",
            "application/vnd.openxmlformats-officedocument.presentationml.presentation",
            "text/plain",
            "image/jpeg",
            "image/png",
        }

        if file.content_type not in ALLOWED_MIME_TYPES:
            raise HTTPException(
                status.HTTP_415_UNSUPPORTED_MEDIA_TYPE,
                detail=f"Тип файла '{file.content_type}' не поддерживается",
            )

        os.makedirs(settings.upload_dir, exist_ok=True)
        ext = os.path.splitext(file.filename)[1]
        stored_name = f"{uuid.uuid4()}{ext}"
        file_path = os.path.join(settings.upload_dir, stored_name)

        content = await file.read()
        if len(content) > settings.max_file_size_mb * 1024 * 1024:
            raise HTTPException(
                status.HTTP_413_REQUEST_ENTITY_TOO_LARGE,
                detail="Файл превышает допустимый размер",
            )
        with open(file_path, "wb") as f:
            f.write(content)

        material = await self._repo.create(
            title=title,
            description=description,
            file_path=file_path,
            file_name=file.filename,
            file_size=len(content),
            mime_type=file.content_type,
            author_id=author_id,
            category_id=category_id,
        )
        await self._analytics.log_event("upload", material.id, author_id)
        return material

    async def delete(self, material_id, requester_id, requester_role):
        material = await self._repo.get(material_id)
        if not material:
            raise HTTPException(status.HTTP_404_NOT_FOUND, detail="Материал не найден")
        # RBAC: teacher удаляет только свои материалы
        if requester_role == "teacher" and material.author_id != requester_id:
            raise HTTPException(status.HTTP_403_FORBIDDEN, detail="Недостаточно прав")
        if os.path.exists(material.file_path):
            os.remove(material.file_path)
        await self._repo.delete(material_id)

    async def get_categories(self):
        return await self._cat_repo.get_all()

    async def create_category(self, name: str, description: str = None,
                               parent_id=None):
        return await self._cat_repo.create(
            name=name, description=description, parent_id=parent_id
        )