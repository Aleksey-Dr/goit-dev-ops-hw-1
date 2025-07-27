# Progect/Django/Dockerfile
# Dockerfile для Django-додатку.
# Цей файл визначає, як буде зібрано образ Docker для Django-додатку.

# Використовуємо офіційний образ Python як базовий
# Рекомендується використовувати конкретну версію Python, наприклад, python:3.9-slim-buster
FROM python:3.9-slim-buster

# Встановлюємо робочий каталог у контейнері
WORKDIR /app

# Копіюємо файл requirements.txt до робочого каталогу
COPY requirements.txt /app/

# Встановлюємо залежності Python
# Використовуємо --no-cache-dir для зменшення розміру образу
RUN pip install --no-cache-dir -r requirements.txt

# Копіюємо весь код додатку до робочого каталогу
COPY . /app/

# Запускаємо міграції бази даних (якщо потрібно)
# Це можна також робити як частину CI/CD пайплайну або init-контейнера в Kubernetes
# RUN python manage.py migrate

# Збираємо статичні файли (якщо потрібно)
# RUN python manage.py collectstatic --noinput

# Відкриваємо порт, на якому буде працювати Django-додаток (за замовчуванням 8000)
EXPOSE 8000

# Команда для запуску Django-додатку за допомогою Gunicorn (рекомендовано для продакшну)
# Замініть "your_project_name.wsgi:application" на шлях до вашого WSGI-файлу
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "django_app.wsgi:application"]

# Альтернативно, для розробки або простих випадків:
# CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
