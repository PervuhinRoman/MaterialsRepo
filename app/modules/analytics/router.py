# SRP: только HTTP-обёртка над AnalyticsService
import csv
import io
from fastapi.responses import StreamingResponse
from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from uuid import UUID

from app.db.session import get_db
from app.core.dependencies import get_current_user, require_role
from app.modules.auth.models import User, Role
from app.modules.analytics.repository import LogRepository
from app.modules.analytics.service import AnalyticsService
from app.modules.analytics.schemas import MaterialStatsOut, SummaryOut, TopMaterialOut
from typing import List

router = APIRouter(prefix="/analytics", tags=["analytics"])


def get_analytics_service(session: AsyncSession = Depends(get_db)) -> AnalyticsService:
    return AnalyticsService(LogRepository(session))


@router.get("/materials/{material_id}", response_model=MaterialStatsOut)
async def material_stats(
    material_id: UUID,
    service: AnalyticsService = Depends(get_analytics_service),
    _: User = Depends(require_role(Role.TEACHER, Role.ADMIN)),
):
    return await service.get_material_stats(material_id)


@router.get("/summary", response_model=SummaryOut)
async def summary(
    service: AnalyticsService = Depends(get_analytics_service),
    _: User = Depends(require_role(Role.ADMIN)),
):
    return await service.get_summary()


@router.get("/top-materials", response_model=List[TopMaterialOut])
async def top_materials(
    limit: int = 10,
    service: AnalyticsService = Depends(get_analytics_service),
    _: User = Depends(require_role(Role.ADMIN)),
):
    return await service.get_top_materials(limit=limit)

@router.get("/export/csv")
async def export_csv(
    service: AnalyticsService = Depends(get_analytics_service),
    _: User = Depends(require_role(Role.ADMIN)),
):

    summary = await service.get_summary()
    top = await service.get_top_materials(limit=20)

    output = io.StringIO()
    writer = csv.writer(output)

    # Сводка
    writer.writerow(["Метрика", "Значение"])
    writer.writerow(["Всего событий", summary["total_events"]])
    writer.writerow(["Просмотров", summary["views"]])
    writer.writerow(["Скачиваний", summary["downloads"]])
    writer.writerow(["Загрузок", summary["uploads"]])
    writer.writerow([])

    # Топ материалов
    writer.writerow(["ID материала", "Название", "Число обращений"])
    for row in top:
        writer.writerow([row["material_id"], row.get("title", ""), row["count"]])

    output.seek(0)
    return StreamingResponse(
        iter([output.getvalue()]),
        media_type="text/csv",
        headers={"Content-Disposition": "attachment; filename=analytics.csv"},
    )
