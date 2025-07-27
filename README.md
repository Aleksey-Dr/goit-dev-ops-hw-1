<a id="top"></a>

# Покрокова Інструкція Виконання Проєкту
Цей посібник допоможе розгорнути комплексну інфраструктуру ***DevOps*** в ***AWS*** за допомогою ***Terraform***, включаючи ***VPC, EKS, RDS, ECR, Jenkins, Argo CD, Prometheus*** та ***Grafana***.

---

**Зміст**

<a href="#1"><img src="https://img.shields.io/badge/Підготовка Середовища-512BD4?style=for-the-badge"/></a> <a href="#2"><img src="https://img.shields.io/badge/Розгортання Інфраструктури-ECD53F?style=for-the-badge"/></a> <a href="#3"><img src="https://img.shields.io/badge/Перевірка Доступності-007054?style=for-the-badge"/></a> <a href="#4"><img src="https://img.shields.io/badge/Моніторинг та Перевірка Метрик (Prometheus & Grafana)-A9225C?style=for-the-badge"/></a> <a href="#5"><img src="https://img.shields.io/badge/Очищення Ресурсів-18AEFF?style=for-the-badge"/></a>

---

<a id="1"></a>

## 1. Підготовка Середовища
### 1.1. Встановлення Необхідних Інструментів
Переконайтеся, що у вас встановлені наступні інструменти:

- ***Terraform***: Завантажити та встановити (версія ```1.0.0``` або вище).

- ***AWS CLI***: Налаштувати та автентифікувати (з відповідними обліковими даними та регіоном).

- ***kubectl***: Встановити (для взаємодії з ***EKS*** кластером).

- ***Helm***: Встановити (для розгортання ***Jenkins***, ***Argo CD***, ***Prometheus***, ***Grafana***).

- ***jq***: Встановити (інструмент командного рядка для обробки ```JSON```, корисний для парсингу виводів ***Terraform***).

- ***yq***: Встановити (інструмент командного рядка для обробки ```YAML```, корисний для оновлення ```values.yaml``` в ***CI/CD***).

### 1.2. Налаштування ***AWS IAM Ролей***
Для коректної роботи ***EKS*** вам знадобляться дві ***IAM*** ролі:

Роль для ***EKS Cluster***: Дозволяє ***EKS*** створювати ресурси ***AWS*** від вашого імені (наприклад, ***Elastic Load Balancers***, ***Security Groups***). Ця роль повинна мати політику ***AmazonEKSClusterPolicy***.

Роль для ***EKS Node Group***: Дозволяє інстансам ***EC2***, які є вузлами ***EKS***, взаємодіяти з ***EKS*** та іншими сервісами ***AWS*** (наприклад, ***ECR***, ***S3***). Ця роль повинна мати політики ***AmazonEKSWorkerNodePolicy***, ***AmazonEC2ContainerRegistryReadOnly***, ***AmazonEKS_CNI_Policy***.

Створіть ці ролі вручну в консолі ***AWS IAM*** або за допомогою окремого ***Terraform-коду***, якщо ви ще цього не зробили. Запишіть їхні ***ARN***.

### 1.3. Ініціалізація ***Terraform Бекенду***
***Terraform*** зберігає свій стан у ***S3 бакеті*** та використовує ***DynamoDB*** для блокування стану, щоб уникнути конфліктів. Це вимагає двохетапної ініціалізації.

1) Перейдіть до кореневого каталогу проєкту:

```bash
cd Progect/
```

2) Відкрийте ```Progect/backend.tf```:

Закоментуйте блок backend ```"s3" { ... }```. Це дозволить ***Terraform*** ініціалізуватися без спроби підключитися до ще неіснуючого віддаленого бекенду.

3) Виконайте початкову ініціалізацію та застосування для створення бекенду:

```bash
terraform init
terraform apply -target=module.s3_backend -auto-approve
```

Ця команда створить ***S3*** бакет та ***DynamoDB*** таблицю.

4) Відкрийте ```Progect/backend.tf``` знову:

Розкоментуйте блок ```backend "s3" { ... }```.

Переконайтеся, що ```bucket```, ```dynamodb_table``` та ```region``` у цьому блоці точно співпадають з назвами, які ви вказали у ```module "s3_backend"```.

5) Виконайте повторну ініціалізацію для підключення до віддаленого бекенду:

```bash
terraform init
```

Тепер ***Terraform*** буде використовувати ***S3*** та ***DynamoDB*** для зберігання та блокування стану.

1.4. Налаштування ```main.tf``` та ```values.yaml```
Відкрийте ```rogect/main.tf``` та внесіть необхідні зміни:

```module "vpc"```: Переконайтеся, що ```vpc_name```, ```vpc_cidr_block```, ```public_subnet_cidrs```, ```private_subnet_cidrs``` відповідають вашим вимогам.

Встановіть ```use_aurora = true``` для ***Aurora*** або ```false``` для звичайної ***RDS***.

Налаштуйте ```engine```, ```engine_version```, ```instance_class``` (для ***RDS***) або ```cluster_instance_class``` (для ***Aurora***).

Створіть файл .env поруч з docker-compose.yaml з такими змінними:

DATABASE_NAME=your_local_db
DATABASE_USER=your_local_user
DATABASE_PASSWORD=your_local_password

[Top :arrow_double_up:](#top)

---

<a id="2"></a>

## 2. Розгортання Інфраструктури 🚀
Переконайтеся, що ви знаходитесь у кореневому каталозі проєкту (```Progect/```).

Перегляньте план розгортання:

```
terraform plan
```

Уважно перегляньте всі ресурси, які будуть створені.

Застосуйте конфігурацію:

```
terraform apply -auto-approve
```

Ця команда розгорне всю інфраструктуру в ***AWS***. Це може зайняти значний час (30-60 хвилин), особливо для ***EKS***.

Оновіть ```kubeconfig``` для взаємодії з ***EKS***:
Після успішного розгортання ***EKS*** кластера, вам потрібно оновити ваш локальний ```kubeconfig``` файл, щоб ```kubectl``` та ***Helm*** могли взаємодіяти з кластером.

```
aws eks update-kubeconfig --name $(terraform output -raw cluster_name) --region eu-central-1
```

Перевірте підключення:

```
kubectl get svc
```

Перевірка стану ресурсів ***Kubernetes***:
Перевірте, чи всі поди та сервіси розгорнуті коректно.

```
kubectl get all -n jenkins
kubectl get all -n argocd
# Для Prometheus та Grafana, якщо ви їх розгорнули:
# kubectl get all -n monitoring
```

[Top :arrow_double_up:](#top)

---

<a id="3"></a>

## 3. Перевірка Доступності

### 3.1. Jenkins
1) Отримайте URL Jenkins:

```
terraform output jenkins_url
```

Якщо ***Jenkins*** розгорнуто з ***LoadBalancer***, ви отримаєте публічний ***DNS-хост***. Якщо ні, вам потрібно буде використовувати ```kubectl port-forward```.

2) Перенаправлення порту (якщо ***LoadBalancer*** не використовується або потрібен локальний доступ):

```
kubectl port-forward svc/jenkins -n jenkins 8080:8080
```

Відкрийте у браузері ```http://localhost:8080```.

3) Отримайте початковий пароль адміністратора ***Jenkins***:

```
terraform output -raw jenkins_admin_password
```

Використовуйте ім'я користувача ```admin``` та отриманий пароль для входу.

### 3.2. ***Argo CD***
1) Отримайте ***URL Argo CD***:

```
terraform output argocd_server_url
```

Якщо ***Argo CD*** розгорнуто з ```LoadBalancer```, ви отримаєте публічний ***DNS-хост***.

2) Перенаправлення порту (якщо ```LoadBalancer``` не використовується або потрібен локальний доступ):

```
kubectl port-forward svc/argocd-server -n argocd 8081:443
```

Відкрийте у браузері ```https://localhost:8081``` (зверніть увагу на ```HTTPS```).

3) Отримайте початковий пароль адміністратора ***Argo CD***:

```
terraform output -raw argocd_initial_admin_password
```

Використовуйте ім'я користувача ```admin``` та отриманий пароль для входу.

[Top :arrow_double_up:](#top)

---

<a id="4"></a>

## 4. Моніторинг та Перевірка Метрик (Prometheus & Grafana)

>[!tip]
>Примітка: Для розгортання ***Prometheus*** та ***Grafana*** потрібно буде додати відповідні ***Helm-чарти*** та їх виклики до ```main.tf``` та ```values.yaml``` (аналогічно ***Jenkins*** та ***Argo CD***).

Після їх розгортання:

1) Перенаправлення порту ***Grafana***:

```
kubectl port-forward svc/grafana -n monitoring 3000:80
```

Відкрийте у браузері ```http://localhost:3000```.

2) Вхід у ***Grafana***:

- Типові облікові дані: ```admin/prom-operator``` (або ```admin/admin```, якщо не змінено чартом).

- Змініть пароль після першого входу.

2) Перевірка стану метрик:

- У ***Grafana*** перейдіть до ***"Data Sources"*** і переконайтеся, що ***Prometheus*** підключено.

- Імпортуйте стандартні дашборди ***Kubernetes*** (наприклад, ***Node Exporter Full***, ***Kubernetes Pods***) або створіть власні, щоб перевірити метрики.

[Top :arrow_double_up:](#top)

---

<a id="5"></a>

## 5. Очищення Ресурсів

⚠️ УВАГА! ⚠️ Видалення інфраструктури ***Terraform*** призводить до видалення всіх ресурсів, включаючи ***S3*** бакет і ***DynamoDB*** таблицю, які використовуються для збереження стану ***Terraform***.

1) Переконайтеся, що ви знаходитесь у кореневому каталозі проєкту (```Progect/```).

2) Виконайте команду знищення:

```
terraform destroy -auto-approve
```

Підтвердіть видалення. Це може зайняти деякий час.

Якщо ви хочете зберегти ***S3*** бакет та ***DynamoDB*** таблицю для стану ***Terraform***:

Видаліть блок ```module "s3_backend"``` з ```Progect/backend.tf```.

Закоментуйте блок ```backend "s3" { ... }``` у ```Progect/backend.tf```.

Виконайте ```terraform init -migrate-state``` (щоб перенести стан локально або відключити бекенд).

Потім виконайте ```terraform destroy -auto-approve```.

Ця інструкція охоплює всі основні етапи розгортання та управління  проєктом ***DevOps***.

[Top :arrow_double_up:](#top)