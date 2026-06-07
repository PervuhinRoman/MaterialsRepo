# OCP: все модели регистрируются здесь — Alembic и main.py импортируют этот файл
# Импорт здесь не вызывает цикла: registry не импортируется из моделей
from app.modules.auth.models import User            # noqa: F401
from app.modules.materials.models import Category, Material  # noqa: F401
from app.modules.analytics.models import AccessLog  # noqa: F401