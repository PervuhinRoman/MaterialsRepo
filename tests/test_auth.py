# Модульные тесты модуля auth (Задание 1 ЛР3)
import pytest


@pytest.mark.asyncio
async def test_register_success(client):
    # Позитивный сценарий: регистрация нового пользователя
    resp = await client.post("/auth/register", json={
        "email": "new@edu.ru",
        "username": "newuser",
        "password": "newpass123",
    })
    assert resp.status_code == 201
    data = resp.json()
    assert data["email"] == "new@edu.ru"
    assert data["role"] == "student"  # роль по умолчанию
    assert "hashed_password" not in data  # пароль не возвращается


@pytest.mark.asyncio
async def test_register_duplicate_email(client):
    # Негативный сценарий: дублирование email
    payload = {"email": "dup@edu.ru", "username": "dup1", "password": "pass123"}
    await client.post("/auth/register", json=payload)
    resp = await client.post("/auth/register", json={
        "email": "dup@edu.ru", "username": "dup2", "password": "pass123"
    })
    assert resp.status_code == 400


@pytest.mark.asyncio
async def test_login_success(client):
    # Позитивный сценарий: успешный вход
    await client.post("/auth/register", json={
        "email": "login@edu.ru", "username": "loginuser", "password": "pass123"
    })
    resp = await client.post("/auth/login", data={
        "username": "login@edu.ru", "password": "pass123"
    })
    assert resp.status_code == 200
    assert "access_token" in resp.json()
    assert resp.json()["token_type"] == "bearer"


@pytest.mark.asyncio
async def test_login_wrong_password(client):
    # Негативный сценарий: неверный пароль → 401
    await client.post("/auth/register", json={
        "email": "wrongpass@edu.ru", "username": "wrongpass", "password": "correct"
    })
    resp = await client.post("/auth/login", data={
        "username": "wrongpass@edu.ru", "password": "wrong"
    })
    assert resp.status_code == 401


@pytest.mark.asyncio
async def test_me_authorized(client, student_headers):
    # Позитивный сценарий: получение профиля с токеном
    resp = await client.get("/auth/me", headers=student_headers)
    assert resp.status_code == 200
    assert resp.json()["email"] == "student@edu.ru"


@pytest.mark.asyncio
async def test_me_unauthorized(client):
    # Негативный сценарий: запрос без токена → 401
    resp = await client.get("/auth/me")
    assert resp.status_code == 401