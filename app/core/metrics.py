# SRP: только настройка Prometheus метрик
# Задание 2 ЛР3: сбор показателей производительности
from prometheus_fastapi_instrumentator import Instrumentator
from prometheus_client import Counter, Histogram, Gauge
import psutil

# --- Кастомные метрики ---

# Счётчик событий по типам (view / download / upload)
material_events = Counter(
    "edu_material_events_total",
    "Количество событий с материалами",
    ["action"],  # label: view | download | upload
)

# Гистограмма времени запросов к БД
db_query_duration = Histogram(
    "edu_db_query_duration_seconds",
    "Время выполнения запросов к БД",
    buckets=[0.01, 0.05, 0.1, 0.25, 0.5, 1.0, 2.5],
)

# Текущее потребление памяти процессом
memory_usage = Gauge(
    "edu_process_memory_bytes",
    "Потребление памяти процессом FastAPI",
)


def update_memory_gauge() -> None:
    # KISS: обновляем метрику памяти при каждом запросе /metrics
    try:
        process = psutil.Process()
        memory_usage.set(process.memory_info().rss)
    except Exception:
        pass


def setup_metrics(app) -> None:
    instrumentator = Instrumentator(
        should_group_status_codes=True,
        should_ignore_untemplated=True,
        should_respect_env_var=False,
        should_instrument_requests_inprogress=True,
        excluded_handlers=["/health", "/metrics"],
    )
    instrumentator.instrument(app).expose(app, endpoint="/metrics")