# Use a base image with Python
FROM python:3.10-slim-buster

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set work directory
WORKDIR /app

# Install dependencies
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# Copy project
COPY . /app/

# Expose port (Django's default runserver port)
EXPOSE 8000

# Run the Django application
# For production, use a more robust WSGI server like Gunicorn
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]