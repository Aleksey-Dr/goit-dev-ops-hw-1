<a id="top"></a>
# Цей репозиторій містить все необхідне для розгортання проєкту DevOps:
## Гнучкий Terraform-модуль для баз даних та Kubernetes-інфраструктури

*Проєкт Terraform надає комплексне рішення для розгортання масштабованої та гнучкої інфраструктури в AWS, включаючи мережеві компоненти, бази даних, реєстр образів Docker та кластер Kubernetes з інструментами CI/CD.*

---

**Зміст**

<a href="#1"><img src="https://img.shields.io/badge/Структура Проєкту-512BD4?style=for-the-badge"/></a> <a href="#2"><img src="https://img.shields.io/badge/Вимоги-ECD53F?style=for-the-badge"/></a> <a href="#3"><img src="https://img.shields.io/badge/Налаштування та Використання-007054?style=for-the-badge"/></a> <a href="#4"><img src="https://img.shields.io/badge/Модулі-A9225C?style=for-the-badge"/></a> <a href="#5"><img src="https://img.shields.io/badge/Helm Чарти-18AEFF?style=for-the-badge"/></a> <a href="#6"><img src="https://img.shields.io/badge/Важливі Примітки-A92EFF?style=for-the-badge"/></a>

---

<a id="1"></a>

## 1. Структура Проєкту

```
Progect/
│
├── main.tf                  # Головний файл для підключення модулів
├── backend.tf               # Налаштування бекенду для стейтів (S3 + DynamoDB)
├── outputs.tf               # Загальні виводи ресурсів
│
├── modules/                 # Каталог з усіма модулями
│   ├── s3-backend/          # Модуль для S3 та DynamoDB
│   │   ├── s3.tf            # Створення S3-бакета
│   │   ├── dynamodb.tf      # Створення DynamoDB
│   │   ├── variables.tf     # Змінні для S3
│   │   └── outputs.tf       # Виведення інформації про S3 та DynamoDB
│   │
│   ├── vpc/                 # Модуль для VPC
│   │   ├── vpc.tf           # Створення VPC, підмереж, Internet Gateway
│   │   ├── routes.tf        # Налаштування маршрутизації
│   │   ├── variables.tf     # Змінні для VPC
│   │   └── outputs.tf       # Виведення інформації про VPC
│   │
│   ├── ecr/                 # Модуль для ECR
│   │   ├── ecr.tf           # Створення ECR репозиторію
│   │   ├── variables.tf     # Змінні для ECR
│   │   └── outputs.tf       # Виведення URL репозиторію
│   │
│   ├── eks/                 # Модуль для Kubernetes кластера
│   │   ├── eks.tf           # Створення кластера EKS та Node Group
│   │   ├── aws_ebs_csi_driver.tf # Встановлення плагіну CSI Driver для EBS
│   │   ├── variables.tf     # Змінні для EKS
│   │   └── outputs.tf       # Виведення інформації про кластер
│   │
│   ├── rds/                 # Модуль для RDS
│   │   ├── rds.tf           # Створення RDS бази даних
│   │   ├── aurora.tf        # Створення aurora кластера бази даних
│   │   ├── shared.tf        # Спільні ресурси (DB Subnet Group, Security Group, Parameter Group)
│   │   ├── variables.tf     # Змінні (ресурси, креденшели, values)
│   │   └── outputs.tf       # Виводи
│   │
│   ├── jenkins/             # Модуль для Helm-установки Jenkins
│   │   ├── jenkins.tf       # Helm release для Jenkins
│   │   ├── variables.tf     # Змінні (ресурси, креденшели, values)
│   │   ├── providers.tf     # Оголошення провайдерів Kubernetes та Helm
│   │   ├── values.yaml      # Конфігурація jenkins
│   │   └── outputs.tf       # Виводи (URL, пароль адміністратора)
│   │
│   └── argo_cd/             # Модуль для Helm-установки Argo CD
│       ├── jenkins.tf       # Helm release для Argo CD (перейменувати на argo_cd.tf)
│       ├── variables.tf     # Змінні (версія чарта, namespace, repo URL тощо)
│       ├── providers.tf     # Kubernetes+Helm провайдери
│       ├── values.yaml      # Кастомна конфігурація Argo CD
│       ├── outputs.tf       # Виводи (hostname, initial admin password)
│       └── charts/                  # Helm-чарт для створення app'ів та репозиторіїв в Argo CD
│           ├── Chart.yaml
│           ├── values.yaml          # Список applications, repositories
│           └── templates/
│               ├── application.yaml
│               └── repository.yaml
│
└── charts/
    └── django-app/
        ├── templates/
        │   ├── deployment.yaml
        │   ├── service.yaml
        │   ├── configmap.yaml
        │   └── hpa.yaml
        ├── Chart.yaml
        └── values.yaml     # ConfigMap зі змінними середовища
```
[Top :arrow_double_up:](#top)

---

<a id="2"></a>

## 2. Вимоги

- ```Terraform``` (версія ```1.0.0``` або вище)

- ```AWS CLI``` (налаштований з відповідними обліковими даними та регіоном)

- ```kubectl``` (для взаємодії з ```EKS``` кластером)

- ```Helm``` (для розгортання ```Jenkins``` та ```Argo CD```)

[Top :arrow_double_up:](#top)

---

<a id="3"></a>

## 3. Налаштування та Використання

### 3.1 Ініціалізація Бекенду

Перед першим запуском ```Terraform``` необхідно створити ```S3``` бакет та ```DynamoDB``` таблицю для зберігання стану ```Terraform```.

Закоментуйте блок ```backend "s3" { ... }``` у файлі ```Progect/backend.tf```.

Перейдіть до кореневого каталогу проєкту (```Progect/```).

***Виконайте***:

```
terraform init
terraform apply -target=module.s3_backend -auto-approve
```

Ця команда створить ```S3``` бакет та ```DynamoDB``` таблицю.

Розкоментуйте блок ```backend "s3" { ... }``` у файлі ```Progect/backend.tf```.

***Виконайте***:

```
terraform init
```

Ця команда переналаштує ```Terraform``` для використання віддаленого бекенду ```S3```.

### 3.2 Розгортання Інфраструктури

Після налаштування бекенду ви можете розгорнути всю інфраструктуру.

Переконайтеся, що ви знаходитесь у кореневому каталозі проєкту (```Progect/```).

***Перегляньте план розгортання***:

```
terraform plan
```

***Застосуйте конфігурацію***:

```
terraform apply -auto-approve
```

### 3.3 Очищення Ресурсів

Щоб уникнути непередбачених рахунків, обов'язково видаляйте створені ресурси після перевірки.

Перейдіть до кореневого каталогу проєкту (```Progect/```).

***Виконайте***:

```
terraform destroy -auto-approve
```

>[!tip]
>Важливо: Ця команда видалить усі ресурси, включаючи ```S3``` бакет та ```DynamoDB``` таблицю, що використовуються для зберігання стану ```Terraform```. Якщо ви хочете зберегти бекенд, вам потрібно буде вручну видалити блок ```module "s3_backend"``` з ```backend.tf``` перед виконанням ```terraform destroy``` для основної інфраструктури.

[Top :arrow_double_up:](#top)

---

<a id="3"></a>

## 4. Модулі

### 4.1 s3-backend

Модуль для створення ```S3``` бакету та ```DynamoDB``` таблиці, які використовуються як бекенд для зберігання стану ```Terraform``` та блокування стану відповідно.

***Розташування***: ```modules/s3-backend/```

***Змінні***:

```bucket_name``` (```string```, обов'язково): Унікальна назва ```S3``` бакету.

```dynamodb_table_name``` (```string```, обов'язково): Унікальна назва ```DynamoDB``` таблиці.

```tags (map(string), default = {})```: Теги для ресурсів.

***Виводи***: ```s3_bucket_id```, ```dynamodb_table_name```.

### 4.2 vpc

Модуль для створення ```Virtual Private Cloud (VPC)``` в ```AWS```, включаючи публічні та приватні підмережі, ```Internet Gateway```, ```NAT Gateway``` та таблиці маршрутизації.

***Розташування***: ```modules/vpc/```

***Змінні***:

```vpc_name``` (```string```, обов'язково): Назва ```VPC```.

```vpc_cidr_block``` (```string```, обов'язково): ```CIDR``` блок для ```VPC``` (наприклад, ```"10.0.0.0/16"```).

```public_subnet_cidrs``` (```list(string)```, обов'язково): Список ```CIDR``` блоків для публічних підмереж (по одній на зону доступності).

```private_subnet_cidrs``` (```list(string)```, обов'язково): Список ```CIDR``` блоків для приватних підмереж (по одній на зону доступності).

```tags``` (```map(string)```, ```default = {}```): Теги для ресурсів.

***Виводи***: ```vpc_id```, ```public_subnet_ids```, ```private_subnet_ids```, ```vpc_cidr_block```.

### 4.3 rds

Універсальний модуль для розгортання реляційних баз даних в ```AWS```, підтримуючи як стандартні інстанси ```RDS``` (```PostgreSQL```, ```MySQL```), так і кластери ```Aurora```. Автоматично створює ```DB Subnet Group```, ```Security Group``` та ```Parameter Group```.

***Розташування***: ```modules/rds/```

***Змінні***:

```use_aurora (bool, default = false): true``` для ```Aurora Cluster```, ```false``` для ```RDS Instance```.

```vpc_id``` (```string```, обов'язково): ```ID VPC```.

```private_subnet_ids``` (```list(string)```, обов'язково): ```ID``` приватних підмереж.

```vpc_cidr_block``` (```string```, обов'язково): ```CIDR``` блок ```VPC```.

```db_name``` (```string```, обов'язково): Назва бази даних.

```username``` (```string```, обов'язково): Ім'я користувача БД.

```password``` (```string```, обов'язково, ```sensitive```): Пароль користувача БД.

```port``` (```number```, обов'язково): Порт БД (```5432``` для ```PostgreSQL```, ```3306``` для ```MySQL```).

```engine``` (```string```, обов'язково): Тип двигуна (```postgresql``` або ```mysql```).

```engine_version``` (```string```, обов'язково): Версія двигуна.

```instance_class``` (```string```, ```default = "db.t3.micro"```): Клас інстансу для ```RDS```.

```allocated_storage (number, default = 20)```: Розмір сховища для ```RDS```.

```multi_az (bool, default = false): Multi-AZ``` для ```RDS```.

```publicly_accessible (bool, default = false)```: Публічний доступ для ```RDS```.

```cluster_instance_class (string, default = "db.t3.medium")```: Клас інстансу для ```Aurora```.

```backup_retention_period (number, default = 7)```: Період зберігання резервних копій для ```Aurora```.

```preferred_backup_window (string, default = "03:00-05:00")```: Вікно резервного копіювання для ```Aurora```.

```skip_final_snapshot (bool, default = true)```: Пропускати фінальний знімок при видаленні.

```tags (map(string), default = {})```: Теги для ресурсів.

***Виводи***: ```db_endpoint```, ```db_port```, ```db_username```, ```db_name```, ```security_group_id```, ```db_subnet_group_name```, ```aurora_cluster_id```, ```rds_instance_id```.

### 4.4 ecr

Модуль для створення репозиторію ```AWS Elastic Container Registry (ECR)``` для зберігання образів ```Docker```.

***Розташування***: ```modules/ecr/```

***Змінні***:

```repository_name``` (```string```, обов'язково): Назва репозиторію ```ECR```.

```tags (map(string), default = {})```: Теги для ресурсів.

***Виводи***: ```repository_arn```, ```repository_url```.

### 4.5 eks

Модуль для створення кластера ```Amazon Elastic Kubernetes Service (EKS)``` та групи вузлів (```Node Group```). Також включає налаштування ```IAM``` та встановлення ```AWS EBS CSI Driver```.

***Розташування***: ```modules/eks/```

***Змінні***:

```cluster_name``` (```string```, обов'язково): Назва кластера ```EKS```.

```kubernetes_version (string, default = "1.28")```: Версія ```Kubernetes```.

```cluster_iam_role_arn``` (```string```, обов'язково): ```ARN IAM``` ролі для кластера ```EKS```.

```vpc_id``` (```string```, обов'язково): ```ID VPC```.

```private_subnet_ids``` (```list(string)```, обов'язково): ```ID``` приватних підмереж для кластера та вузлів.

```vpc_cidr_block``` (```string```, обов'язково): ```CIDR``` блок ```VPC```.

```enable_public_endpoint_access (bool, default = false)```: Дозволити публічний доступ до ```API```.

```node_instance_types (list(string), default = ["t3.medium"])```: Типи інстансів для вузлів.

```node_iam_role_arn``` (```string```, обов'язково): ```ARN IAM``` ролі для вузлів ```EKS```.

```node_group_min_size (number, default = 1)```: Мінімальна кількість інстансів у групі вузлів.

```node_group_max_size (number, default = 3)```: Максимальна кількість інстансів у групі вузлів.

```node_group_desired_size (number, default = 1)```: Бажана кількість інстансів у групі вузлів.

```tags (map(string), default = {})```: Теги для ресурсів.

***Виводи***: ```cluster_name```, ```cluster_endpoint```, ```cluster_certificate_authority_data```, ```cluster_oidc_issuer_url```, ```node_group_name```, ```node_group_arn```, ```eks_cluster_security_group_id```.

### 4.6 jenkins

Модуль для розгортання ```Jenkins``` у кластері ```Kubernetes``` за допомогою ```Helm```.

***Розташування***: ```modules/jenkins/```

***Змінні***:

```release_name (string, default = "jenkins")```: Назва релізу ```Helm```.

```namespace (string, default = "jenkins")```: Простір імен ```Kubernetes```.

```chart_name (string, default = "jenkins")```: Назва ```Helm``` чарту.

```chart_version (string, default = "4.10.0")```: Версія ```Helm``` чарту.

```chart_repository (string, default = "https://charts.jenkins.io")```: ```URL``` репозиторію ```Helm```.

```set_values (list(object), default = [])```: Додаткові значення ```Helm```.

```tags (map(string), default = {})```: Теги для ресурсів.

***Виводи***: ```jenkins_url```, ```jenkins_admin_password```.

### 4.7 argo_cd

Модуль для розгортання ```Argo CD``` у кластері ```Kubernetes``` за допомогою ```Helm```. Включає вкладений ```Helm```-чарт для автоматичного створення ```Argo CD Applications``` та ```Repositories```.

***Розташування***: ```modules/argo_cd/```

***Змінні***:

```release_name (string, default = "argo-cd")```: Назва релізу ```Helm```.

```namespace (string, default = "argocd")```: Простір імен ```Kubernetes```.

```chart_name (string, default = "argo-cd")```: Назва ```Helm``` чарту.

```chart_version (string, default = "5.36.0")```: Версія ```Helm``` чарту.

```chart_repository (string, default = "https://argoproj.github.io/argo-helm")```: ```URL``` репозиторію ```Helm```.

```set_values (list(object), default = [])```: Додаткові значення ```Helm```.

```tags (map(string), default = {})```: Теги для ресурсів.

***Виводи***: ```argocd_server_url```, ```argocd_initial_admin_password```.

[Top :arrow_double_up:](#top)

---

<a id="5"></a>

## 5. Helm Чарти

### django-app

Приклад ```Helm``` чарту для розгортання ```Django```-додатку в кластері ```Kubernetes```. Включає ```Deployment```, ```Service```, ```ConfigMap``` та ```Horizontal Pod Autoscaler```.

***Розташування***: ```charts/django-app/```

***Конфігурація***: Налаштовується через ```values.yaml``` у каталозі чарту.

```replicaCount```: Кількість реплік.

```image```: Образ ```Docker``` та політика отримання.

```service```: Тип сервісу (```ClusterIP```, ```NodePort```, ```LoadBalancer```) та порт.

```autoscaling```: Налаштування ```HPA```.

```config.database```: Змінні середовища для підключення до бази даних.

[Top :arrow_double_up:](#top)

---

<a id="6"></a>

## 6. Важливі Примітки

***Паролі та чутливі дані***: Завжди використовуйте надійні паролі та керуйте ними безпечно. У цьому проєкті паролі передаються через змінні ```Terraform```, позначені як ```sensitive```, що запобігає їх виводу в консоль. Для продакшну розгляньте використання ```AWS Secrets Manager``` або інших систем управління секретами.

***Регіон ```AWS```***: Переконайтеся, що регіон ```AWS```, вказаний у ```backend.tf``` та ```provider "aws" {}```, відповідає вашим потребам.

***Унікальні назви***: Назви ```S3``` бакетів та ```DynamoDB``` таблиць повинні бути глобально унікальними. Змініть їх у ```backend.tf``` перед використанням.

***Версії***: Перевіряйте актуальні версії чартів ```Helm``` та ```Kubernetes/двигунів RDS```, оскільки вони можуть змінюватися.

***Права ```IAM```***: Переконайтеся, що облікові дані ```AWS```, які ви використовуєте, мають достатні права для створення та управління всіма ресурсами, визначеними в ```Terraform```.

***Модуль ```Argo CD```***: Зверніть увагу, що файл ```jenkins.tf``` у модулі ```argo_cd``` слід перейменувати на ```argo_cd.tf``` для кращої відповідності назві модуля.

***Підключення до EKS***: Після розгортання ```EKS``` кластера вам потрібно буде оновити ваш ```kubeconfig``` файл, щоб ```kubectl``` та ```Helm``` могли взаємодіяти з кластером. Це можна зробити за допомогою команди ```AWS CLI```:

```
aws eks update-kubeconfig --name <your-cluster-name> --region <your-aws-region>
```

[Top :arrow_double_up:](#top)