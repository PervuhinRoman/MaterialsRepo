# Интеграционные тесты модуля analytics (Задание 1 ЛР3)
# Проверяем межмодульное взаимодействие: materials -> analytics
import pytest
import io


@pytest.mark.asyncio
async def test_view_logs_event(client, teacher_headers, student_headers, admin_headers):
    # Интеграционный: просмотр материала создаёт лог события
    upload = await client.post(
        "/materials",
        headers=teacher_headers,
        files={"file": ("analytics.txt", io.BytesIO(b"data"), "text/plain")},
        data={"title": "Аналитика"},
    )
    material_id = upload.json()["id"]

    # Студент просматривает материал
    await client.get(f"/materials/{material_id}", headers=student_headers)

    # Admin проверяет статистику
    resp = await client.get(
        f"/analytics/materials/{material_id}", headers=admin_headers
    )
    assert resp.status_code == 200
    data = resp.json()
    assert data["total"] >= 1
    assert data["views"] >= 1


@pytest.mark.asyncio
async def test_summary_admin_only(client, admin_headers, student_headers):
    # Позитивный: admin получает сводку
    resp = await client.get("/analytics/summary", headers=admin_headers)
    assert resp.status_code == 200
    assert "total_events" in resp.json()

    # Негативный: student не получает сводку → 403
    resp = await client.get("/analytics/summary", headers=student_headers)
    assert resp.status_code == 403


@pytest.mark.asyncio
async def test_top_materials(client, admin_headers):
    # Позитивный: топ материалов доступен admin
    resp = await client.get("/analytics/top-materials", headers=admin_headers)
    assert resp.status_code == 200
    assert isinstance(resp.json(), list)