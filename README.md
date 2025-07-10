<a id="top"></a>

Цей репозиторій містить Django-додаток, розроблений для розгортання в середовищі AWS EKS за допомогою Terraform. Проект включає в себе налаштування для розробки API, контейнеризації з Docker та автоматизації інфраструктури як коду (IaC).

<a href="#1"><img src="https://img.shields.io/badge/Швидкий Старт-512BD4?style=for-the-badge"/></a> <a href="#2"><img src="https://img.shields.io/badge/Docker-ECD53F?style=for-the-badge"/></a> <a href="#3"><img src="https://img.shields.io/badge/AWS Інфраструктура з Terraform-007054?style=for-the-badge"/></a> <a href="#4"><img src="https://img.shields.io/badge/Kubernetes (EKS)-A9225C?style=for-the-badge"/></a> <a href="#5"><img src="https://img.shields.io/badge/Очищення Локального Docker Середовища-18AEFF?style=for-the-badge"/></a> <a href="#6"><img src="https://img.shields.io/badge/Важливі Зауваження-A92EFF?style=for-the-badge"/></a>

<a id="1"></a>

### 🚀 Швидкий Старт
Для того щоб розгорнути та запустити цей проект локально або в ***AWS***, виконайте наступні кроки:

#### 1. Передумови
Перед початком переконайтеся, що у вас встановлено:

- Git
- Docker та Docker Compose
- Python 3.x
- pip (менеджер пакетів Python)
- Terraform (версія 1.0+)
- AWS CLI (налаштований з відповідними правами доступу)
- kubectl (для взаємодії з Kubernetes)
- Helm (для розгортання додатків у Kubernetes)

#### 2. Клонування Репозиторію

```Bash
git clone <URL вашого репозиторію>
cd goit-dev-ops-hw-1 # або інша назва вашої кореневої папки
```

#### 3. Налаштування Локального Середовища

##### 3.1. Віртуальне Оточення Python

Створіть та активуйте віртуальне оточення:

```Bash
python3 -m venv venv
source venv/bin/activate # Для Linux/macOS
# Або .\venv\Scripts\activate # Для Windows (PowerShell)
```

##### 3.2. Встановлення Залежностей

Встановіть залежності Python з ```requirements.txt```:

```Bash
pip install -r django-goit-app/requirements.txt
```

##### 3.3. Файл Змінних Середовища (.env)

Створіть файл ```.env``` у кореневій директорії ***Django-додатка*** (```django-goit-app/.env```) для локальної розробки та додайте необхідні змінні. Цей файл повинен бути у ```.gitignore```!

Приклад ```.env```:
```
SECRET_KEY=your_super_secret_key_for_dev
DEBUG=True
ALLOWED_HOSTS=127.0.0.1,localhost
DATABASE_URL=sqlite:///db.sqlite3
```

##### 3.4. Міграції Бази Даних (локально)
Перейдіть в директорію проекту ***Django*** та виконайте міграції:

```Bash
cd django-goit-app/
python manage.py makemigrations
python manage.py migrate
cd .. # Поверніться в кореневу папку goit-dev-ops-hw-1
```
[Top :arrow_double_up:](#top)

<a id="2"></a>

### 🐳 Docker
Проект контейнеризований за допомогою ***Docker***.

#### 1. Збірка Docker-образу
Переконайтеся, що ви знаходитесь в кореневій директорії проекту (наприклад, ```dev-ops```).

```Bash
docker build -t django-goit-app:latest ./django-goit-app
```

#### 2. Запуск Контейнера (локально)
Ви можете запустити додаток у Docker-контейнері локально:

```Bash
docker run -p 8000:8000 django-goit-app:latest
```

Додаток буде доступний за адресою ```http://localhost:8000```.
[Top :arrow_double_up:](#top)

<a id="3"></a>

### ☁️ AWS Інфраструктура з Terraform

Інфраструктура ***AWS*** розгортається за допомогою ***Terraform***.

#### 1. Ініціалізація Terraform

Перейдіть в директорію ***Terraform-проекту*** <name d>:

```Bash
cd <name d>
terraform init
```

Ця команда ініціалізує робочу директорію ***Terraform***, завантажує необхідні провайдери та налаштовує віддалений бекенд ***S3*** для зберігання стану ***Terraform*** та таблицю ***DynamoDB*** для блокування стану.

#### 2. Перевірка Плану Розгортання
Перегляньте, які ресурси будуть створені:

```Bash
terraform plan
```

>[!Tip]
>Уважно перевірте вивід цієї команди, щоб переконатися, що створюються саме ті ресурси, які ви очікуєте.

#### 3. Застосування Плану (Розгортання)
Застосуйте зміни та розгорніть інфраструктуру в ***AWS***:

```Bash
terraform apply
```
Введіть ```yes```, коли буде запропоновано підтвердити.

#### 4. Знищення Інфраструктури (Очищення Затрат)
Після завершення роботи з проектом для уникнення непотрібних витрат обов'язково знищіть всі розгорнуті ресурси. Переконайтеся, що ви перебуваєте в директорії.

```Bash
terraform destroy
```

Введіть ```yes```, коли буде запропоновано підтвердити.

>[!Tip]
>Якщо виникне помилка блокування стану (```Error: Error acquiring the state lock```) через відсутність таблиці ***DynamoDB***, повторіть команду з прапором ```-lock=false```:

```Bash
terraform destroy -lock=false
```
[Top :arrow_double_up:](#top)

<a id="4"></a>

### 🌐 Kubernetes (EKS)

Після розгортання ***EKS-кластера*** за допомогою ***Terraform*** ви зможете взаємодіяти з ним за допомогою ***kubectl*** та розгортати додаток.

#### 1. Оновлення ***Kubeconfig***

***Terraform*** виведе команду для оновлення вашого ***kubeconfig***. Виконайте її:

```Bash
aws eks update-kubeconfig --region <ваш_регіон> --name <ім'я_вашого_EKS_кластера>
```

Приклад:

```Bash
aws eks update-kubeconfig --region eu-central-1 --name goit-django-eks-cluster
```

#### 2. Перевірка Кластера

Перевірте, чи кластер доступний:

```Bash
kubectl get svc
kubectl get nodes
```

#### 3. Розгортання Додатка в EKS (з Helm або Kustomize)

Для розгортання ***Django-додатка*** в ***EKS***, ви зазвичай використовуєте ***Helm-чарт*** або ***Kustomize***. Деталі розгортання будуть залежати від ваших ***Kubernetes-маніфестів***.
[Top :arrow_double_up:](#top)

<a id="5"></a>

### 🧹 Очищення Локального Docker Середовища

Для очищення локальних ***Docker-ресурсів***:

Зупинити всі контейнери:

```Bash
docker stop $(docker ps -aq)
```

Видалити всі зупинені контейнери:

```Bash
docker container prune
```

Видалити всі невикористовувані образи (***dangling images***):

```Bash
docker image prune
```

Очистити всю систему ***Docker*** (обережно! видалить також невикористовувані томи):

```Bash
docker system prune --volumes
```
[Top :arrow_double_up:](#top)

<a id="6"></a>

### ⚠️ Важливі Зауваження

Безпека: Ніколи не зберігайте чутливі дані (ключі ***API***, паролі) безпосередньо в коді або в Git-репозиторії. Використовуйте змінні середовища, ***AWS Secrets Manager*** або ***Kubernetes Secrets***.

Витрати ***AWS***: Розгортання ресурсів в ***AWS*** коштує грошей. Завжди пам'ятайте про необхідність знищення ресурсів після завершення роботи з ними за допомогою ***terraform destroy***. Регулярно перевіряйте сторінку ***Billing*** у вашій консолі ***AWS***.

Регіон AWS: Переконайтеся, що ви працюєте в потрібному регіоні AWS.

Ця документація допоможе вам почати роботу з проектом. Якщо виникають питання, звертайтеся до відповідних файлів конфігурації ***Terraform, Dockerfile*** або коду ***Django***.

Цей проєкт налаштовує основну інфраструктуру AWS за допомогою ***Terraform***, включаючи ***S3*** та ***DynamoDB*** для керування станом, ***Virtual Private Cloud (VPC)*** з публічними та приватними підмережами, а також ***Elastic Container Registry (ECR)*** для образів ***Docker***.

[Top :arrow_double_up:](#top)