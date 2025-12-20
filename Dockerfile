FROM python:3.11-slim

WORKDIR /app

# Копируем весь проект. http.server будет раздавать файлы из этой директории.
COPY . /app

# Порт по умолчанию — 8000, если хочешь другой — поменяй.
EXPOSE 8000

# Запуск встроенного HTTP-сервера Python
CMD ["python3.11", "-m", "http.server", "8000", "--bind", "0.0.0.0"]
