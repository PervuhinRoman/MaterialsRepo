# Нагрузочное тестирование — Задание 2-3 ЛР3
from locust import HttpUser, task, between


class EduRepoUser(HttpUser):
    wait_time = between(1, 3)  # пауза между запросами 1-3 сек
    token: str = ""

    def on_start(self):
        # Логинимся один раз при старте виртуального пользователя
        resp = self.client.post("/auth/login", data={
            "username": "student@edu.ru",
            "password": "student123",
        })
        self.token = resp.json().get("access_token", "")

    def _headers(self):
        return {"Authorization": f"Bearer {self.token}"}

    @task(5)  # вес 5 — чаще всего запрашивают список
    def list_materials(self):
        self.client.get("/materials", headers=self._headers())

    @task(2)
    def health_check(self):
        self.client.get("/health")

    @task(1)
    def get_analytics_summary(self):
        # Этот запрос вернёт 403 для student — это нормально,
        # нас интересует время ответа даже на отказ
        self.client.get("/analytics/summary", headers=self._headers())