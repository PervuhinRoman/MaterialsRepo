# Модульные + интеграционные тесты модуля materials (Задание 1 ЛР3)
import pytest
import io


@pytest.mark.asyncio
async def test_upload_as_teacher(client, teacher_headers):
    # Интеграционный: teacher загружает файл → материал создан
    resp = await client.post(
        "/materials",
        headers=teacher_headers,
        files={"file": ("test.txt", io.BytesIO(b"content"), "text/plain")},
        data={"title": "Лекция 1", "description": "Описание"},
    )
    assert resp.status_code == 201
    data = resp.json()
    assert data["title"] == "Лекция 1"
    assert data["file_name"] == "test.txt"
    assert data["download_count"] == 0


@pytest.mark.asyncio
async def test_upload_as_student_forbidden(client, student_headers):
    # Негативный: student не может загружать → 403
    resp = await client.post(
        "/materials",
        headers=student_headers,
        files={"file": ("test.txt", io.BytesIO(b"content"), "text/plain")},
        data={"title": "Попытка загрузки"},
    )
    assert resp.status_code == 403


@pytest.mark.asyncio
async def test_list_materials(client, student_headers, teacher_headers):
    # Интеграционный: загружаем и читаем список
    await client.post(
        "/materials",
        headers=teacher_headers,
        files={"file": ("list_test.txt", io.BytesIO(b"data"), "text/plain")},
        data={"title": "Для списка"},
    )
    resp = await client.get("/materials", headers=student_headers)
    assert resp.status_code == 200
    assert isinstance(resp.json(), list)
    assert len(resp.json()) >= 1


@pytest.mark.asyncio
async def test_get_material_by_id(client, teacher_headers, student_headers):
    # Интеграционный: загрузка → чтение по id
    upload = await client.post(
        "/materials",
        headers=teacher_headers,
        files={"file": ("detail.txt", io.BytesIO(b"detail"), "text/plain")},
        data={"title": "Детальный просмотр"},
    )
    material_id = upload.json()["id"]
    resp = await client.get(f"/materials/{material_id}", headers=student_headers)
    assert resp.status_code == 200
    assert resp.json()["id"] == material_id


@pytest.mark.asyncio
async def test_get_material_unauthorized(client, teacher_headers):
    # Негативный: без токена → 401
    upload = await client.post(
        "/materials",
        headers=teacher_headers,
        files={"file": ("unauth.txt", io.BytesIO(b"x"), "text/plain")},
        data={"title": "Без токена"},
    )
    material_id = upload.json()["id"]
    resp = await client.get(f"/materials/{material_id}")
    assert resp.status_code == 401


@pytest.mark.asyncio
async def test_delete_own_material(client, teacher_headers):
    # Позитивный: teacher удаляет свой материал
    upload = await client.post(
        "/materials",
        headers=teacher_headers,
        files={"file": ("del.txt", io.BytesIO(b"bye"), "text/plain")},
        data={"title": "На удаление"},
    )
    material_id = upload.json()["id"]
    resp = await client.delete(f"/materials/{material_id}", headers=teacher_headers)
    assert resp.status_code == 204


@pytest.mark.asyncio
async def test_create_category_as_admin(client, admin_headers):
    # Позитивный: admin создаёт категорию
    resp = await client.post(
        "/materials/categories",
        headers=admin_headers,
        json={"name": "Физика", "description": "Физические дисциплины"},
    )
    assert resp.status_code == 201
    assert resp.json()["name"] == "Физика"


@pytest.mark.asyncio
async def test_create_category_as_student_forbidden(client, student_headers):
    # Негативный: student не может создавать категории → 403
    resp = await client.post(
        "/materials/categories",
        headers=student_headers,
        json={"name": "Запрещённая"},
    )
    assert resp.status_code == 403