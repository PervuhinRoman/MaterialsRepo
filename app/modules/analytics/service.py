# SRP: только бизнес-логика аналитики
import time
from uuid import UUID
from typing import Optional
from app.modules.analytics.repository import LogRepository
from app.core.metrics import material_events

# KISS: простой TTL-кэш без внешних зависимостей
_top_cache: dict = {"data": None, "expires_at": 0.0}
_CACHE_TTL = 60  # секунд


class AnalyticsService:

    def __init__(self, repo: LogRepository):
        self._repo = repo

    async def log_event(
        self,
        action: str,
        material_id: Optional[UUID] = None,
        user_id: Optional[UUID] = None,
        ip_address: Optional[str] = None,
    ) -> None:
        await self._repo.create(
            action=action,
            material_id=material_id,
            user_id=user_id,
            ip_address=ip_address,
        )
        material_events.labels(action=action).inc()
        # Инвалидируем кэш при новом событии
        _top_cache["expires_at"] = 0.0

    async def get_material_stats(self, material_id: UUID) -> dict:
        logs = await self._repo.get_by_material(material_id)
        return {
            "material_id": str(material_id),
            "total": len(logs),
            "views": sum(1 for l in logs if l.action == "view"),
            "downloads": sum(1 for l in logs if l.action == "download"),
        }

    async def get_top_materials(self, limit: int = 10):
        # DRY: кэш проверяется в одном месте
        now = time.monotonic()
        if _top_cache["data"] is not None and now < _top_cache["expires_at"]:
            return _top_cache["data"]

        result = await self._repo.get_top_materials(limit)
        _top_cache["data"] = result
        _top_cache["expires_at"] = now + _CACHE_TTL
        return result

    async def get_summary(self) -> dict:
        logs = await self._repo.get_all(limit=10000)
        return {
            "total_events": len(logs),
            "views": sum(1 for l in logs if l.action == "view"),
            "downloads": sum(1 for l in logs if l.action == "download"),
            "uploads": sum(1 for l in logs if l.action == "upload"),
        }