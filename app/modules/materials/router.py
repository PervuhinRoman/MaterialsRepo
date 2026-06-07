# SRP: только HTTP-обёртка над MaterialsService
from fastapi import APIRouter, Depends, UploadFile, File, Form, Request
from fastapi.responses import FileResponse
from sqlalchemy.ext.asyncio import AsyncSession
from typing import List, Optional
from uuid import UUID

from app.db.session import get_db
from app.core.dependencies import get_current_user, require_role
from app.modules.auth.models import User, Role
from app.modules.materials.repository import MaterialRepository, CategoryRepository
from app.modules.materials.service import MaterialsService
from app.modules.analytics.repository import LogRepository
from app.modules.analytics.service import AnalyticsService
from app.modules.materials.schemas import (
    MaterialOut, MaterialUpdate, CategoryCreate, CategoryOut
)

router = APIRouter(prefix="/materials", tags=["materials"])


def get_materials_service(session: AsyncSession = Depends(get_db)) -> MaterialsService:
    # DIP: сборка всего графа зависимостей в одном месте
    return MaterialsService(
        repo=MaterialRepository(session),
        category_repo=CategoryRepository(session),
        analytics=AnalyticsService(LogRepository(session)),
    )


@router.get("", response_model=List[MaterialOut])
async def list_materials(
    skip: int = 0,
    limit: int = 100,
    service: MaterialsService = Depends(get_materials_service),
    _: User = Depends(get_current_user),
):
    return await service.get_all(skip=skip, limit=limit)


@router.post("", response_model=MaterialOut, status_code=201)
async def upload_material(
    request: Request,
    file: UploadFile = File(...),
    title: str = Form(...),
    description: Optional[str] = Form(None),
    category_id: Optional[UUID] = Form(None),
    service: MaterialsService = Depends(get_materials_service),
    current_user: User = Depends(require_role(Role.TEACHER, Role.ADMIN)),
):
    return await service.upload(
        file=file,
        title=title,
        description=description,
        author_id=current_user.id,
        category_id=category_id,
    )


@router.get("/{material_id}", response_model=MaterialOut)
async def get_material(
    material_id: UUID,
    request: Request,
    service: MaterialsService = Depends(get_materials_service),
    current_user: User = Depends(get_current_user),
):
    return await service.get_by_id(
        material_id,
        user_id=current_user.id,
        ip=request.client.host,
    )


@router.put("/{material_id}", response_model=MaterialOut)
async def update_material(
    material_id: UUID,
    data: MaterialUpdate,
    service: MaterialsService = Depends(get_materials_service),
    current_user: User = Depends(require_role(Role.TEACHER, Role.ADMIN)),
):
    # DRY: update делегируется репозиторию через сервис
    repo = service._repo
    return await repo.update(material_id, **data.model_dump(exclude_none=True))


@router.delete("/{material_id}", status_code=204)
async def delete_material(
    material_id: UUID,
    service: MaterialsService = Depends(get_materials_service),
    current_user: User = Depends(require_role(Role.TEACHER, Role.ADMIN)),
):
    await service.delete(material_id, current_user.id, current_user.role.value)


@router.get("/{material_id}/download")
async def download_material(
    material_id: UUID,
    request: Request,
    service: MaterialsService = Depends(get_materials_service),
    current_user: User = Depends(get_current_user),
):
    material = await service._repo.get(material_id)
    await service._analytics.log_event(
        "download", material_id, current_user.id, request.client.host
    )
    await service._repo.increment_downloads(material_id)
    return FileResponse(
        path=material.file_path,
        filename=material.file_name,
        media_type=material.mime_type,
    )


# --- Категории ---

@router.get("/categories/all", response_model=List[CategoryOut])
async def list_categories(
    service: MaterialsService = Depends(get_materials_service),
    _: User = Depends(get_current_user),
):
    return await service.get_categories()


@router.post("/categories", response_model=CategoryOut, status_code=201)
async def create_category(
    data: CategoryCreate,
    service: MaterialsService = Depends(get_materials_service),
    _: User = Depends(require_role(Role.ADMIN)),
):
    return await service.create_category(
        name=data.name,
        description=data.description,
        parent_id=data.parent_id,
    )