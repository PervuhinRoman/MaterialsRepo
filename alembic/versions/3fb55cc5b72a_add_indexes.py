"""add_indexes

Revision ID: 3fb55cc5b72a
Revises: 3c613832a501
Create Date: 2026-06-05 23:22:31.891369

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '3fb55cc5b72a'
down_revision: Union[str, None] = '3c613832a501'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # Индекс по автору — ускоряет фильтрацию материалов по преподавателю
    op.create_index("ix_materials_author_id",
                    "materials", ["author_id"])
    # Индекс по категории — ускоряет фильтрацию по разделу
    op.create_index("ix_materials_category_id",
                    "materials", ["category_id"])
    # Индекс по времени события — ускоряет сортировку логов
    op.create_index("ix_access_logs_created_at",
                    "access_logs", ["created_at"])
    # Индекс по material_id в логах — ускоряет агрегацию статистики
    op.create_index("ix_access_logs_material_id",
                    "access_logs", ["material_id"])


def downgrade() -> None:
    op.drop_index("ix_materials_author_id", "materials")
    op.drop_index("ix_materials_category_id", "materials")
    op.drop_index("ix_access_logs_created_at", "access_logs")
    op.drop_index("ix_access_logs_material_id", "access_logs")
