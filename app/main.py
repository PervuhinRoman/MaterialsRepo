# OCP: новые модули подключаются через include_router без правки существующего кода
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from contextlib import asynccontextmanager

from app.core.config import get_settings
from app.core.logging import setup_logging, get_logger
from app.core.middleware import LoggingMiddleware
from app.core.metrics import setup_metrics
from app.db import registry  # noqa: F401
from app.modules.auth.router import router as auth_router
from app.modules.materials.router import router as materials_router
from app.modules.analytics.router import router as analytics_router

settings = get_settings()
setup_logging()
logger = get_logger("main")


@asynccontextmanager
async def lifespan(app: FastAPI):
    logger.info("Приложение запущено")
    yield
    logger.info("Приложение остановлено")


app = FastAPI(
    title="Репозиторий учебных материалов",
    version="0.1.0",
    description="API для хранения, систематизации и аналитики учебных материалов",
    lifespan=lifespan,
    redirect_slashes=False,
)

# Порядок важен: сначала CORS, затем логирование
app.add_middleware(CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
app.add_middleware(LoggingMiddleware)

setup_metrics(app)

app.include_router(auth_router)
app.include_router(materials_router)
app.include_router(analytics_router)


@app.get("/health", tags=["system"])
async def health():
    # KISS: простая проверка для Docker healthcheck и мониторинга
    return {"status": "ok"}