# SRP: middleware отвечает только за логирование запросов и сбор метрик времени
import time
import uuid
from fastapi import Request
from starlette.middleware.base import BaseHTTPMiddleware
from app.core.logging import get_logger

logger = get_logger("request")


class LoggingMiddleware(BaseHTTPMiddleware):

    async def dispatch(self, request: Request, call_next):
        # KISS: уникальный ID запроса для трассировки в логах
        request_id = str(uuid.uuid4())[:8]
        start = time.perf_counter()

        logger.info(
            f"[{request_id}] → {request.method} {request.url.path} "
            f"client={request.client.host if request.client else 'unknown'}"
        )

        response = await call_next(request)

        duration_ms = (time.perf_counter() - start) * 1000
        logger.info(
            f"[{request_id}] ← {response.status_code} "
            f"duration={duration_ms:.1f}ms path={request.url.path}"
        )

        # Добавляем заголовок с временем ответа — удобно для отладки
        response.headers["X-Response-Time"] = f"{duration_ms:.1f}ms"
        return response