# Dockerfile

# Використовуємо офіційний образ Python останньої стабільної версії (наприклад, 3.12)
FROM python:3.12-slim-bookworm

# Встановлюємо робочу директорію в контейнері
WORKDIR /app

# Копіюємо файл залежностей та встановлюємо їх
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Копіюємо весь код Django-проєкту в контейнер
COPY . .

# Виставляємо порт, на якому буде працювати Gunicorn
EXPOSE 8000

# Команда для запуску Gunicorn
# Примітка: config - це назва Django-проєкту (папки, де знаходиться settings.py)
CMD ["python", "-m", "gunicorn", "--bind", "0.0.0.0:8000", "config.wsgi"]