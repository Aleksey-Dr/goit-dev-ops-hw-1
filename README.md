<a id="top"></a>
# DevOps CI/CD пайплайн для Django-додатку на AWS EKS

-----

Цей репозиторій містить все необхідне для розгортання CI/CD пайплайну для Django-додатку на Amazon EKS, використовуючи Terraform для інфраструктури, Jenkins для автоматизації збирання та розгортання, і Argo CD для GitOps.

## Зміст

  <a href="#1"><img src="https://img.shields.io/badge/Попередні вимоги-512BD4?style=for-the-badge"/></a> <a href="#2"><img src="https://img.shields.io/badge/Структура проєкту-ECD53F?style=for-the-badge"/></a> <a href="#3"><img src="https://img.shields.io/badge/Як застосувати Terraform-007054?style=for-the-badge"/></a> <a href="#4"><img src="https://img.shields.io/badge/Як перевірити Jenkins Job-A9225C?style=for-the-badge"/></a> <a href="#5"><img src="https://img.shields.io/badge/Як побачити результат в Argo CD-18AEFF?style=for-the-badge"/></a> <a href="#6"><img src="https://img.shields.io/badge/Очищення-A92EFF?style=for-the-badge"/></a>

-----

<a id="1"></a>
## Попередні вимоги

Перш ніж почати, переконайтеся, що у вас встановлені та налаштовані наступні інструменти:

  * **AWS CLI**: Налаштований з правами адміністратора або відповідними IAM-ролями для створення ресурсів (EKS, ECR, IAM, VPC тощо).
  * **Terraform**: `v1.0.0` або вище.
  * **kubectl**: Налаштований для взаємодії з кластером Kubernetes.
  * **Helm**: Для роботи з Helm-чартами.
  * **Git**: Для взаємодії з репозиторіями.
  * **`jq`**: Утиліта для обробки JSON (часто використовується з AWS CLI).
  * **`envsubst`**: Утиліта для підстановки змінних середовища у файли (часто входить до пакету `gettext`).
  * **Python 3 та `pip`**: Для генерації Django Secret Key та інших Python-скриптів.
  * **`gh` CLI (GitHub CLI)**: Якщо ви використовуєте GitHub, це спростить створення репозиторію.

[Top :arrow_double_up:](#top)

-----

<a id="2"></a>
## Структура&nbsp;проєкту

```
Project/
├── main.tf                 # Головний файл Terraform, що об'єднує всі модулі.
├── outputs.tf              # Виведення Terraform (наприклад, URL ECR, ім'я кластера EKS).
├── variables.tf            # Глобальні змінні Terraform.
├── modules/
│   ├── vpc/                # Модуль Terraform для налаштування VPC та підмереж.
│   ├── eks/                # Модуль Terraform для розгортання EKS-кластера.
│   ├── ecr/                # Модуль Terraform для створення репозиторію ECR.
│   ├── jenkins/            # Модуль Terraform для розгортання Jenkins на EKS з IRSA.
│   └── argo_cd/            # Модуль Terraform для розгортання Argo CD на EKS.
├── django-app-repo/
│   ├── Dockerfile          # Dockerfile для вашого Django-додатку.
│   ├── Jenkinsfile         # Jenkins Pipeline definition.
│   ├── requirements.txt    # Залежності Python для Django.
│   └── ... (ваш код Django-додатку)
├── charts/
│   └── django-app/         # Helm-чарт для вашого Django-додатку.
│       ├── Chart.yaml
│       ├── values.yaml
│       └── templates/
│           └── ... (Kubernetes маніфести)
└── README.md               # Цей файл
```

[Top :arrow_double_up:](#top)

-----

<a id="3"></a>
## Як застосувати Terraform

Цей розділ описує процес розгортання всієї необхідної інфраструктури AWS та інструментів CI/CD (Jenkins, Argo CD) з використанням Terraform.

### 1\. Підготовка репозиторію Helm-чартів

Вам потрібен окремий Git-репозиторій для ваших Helm-чартів. Jenkins буде оновлювати `values.yaml` у цьому репозиторії, а Argo CD буде відстежувати його.

1.  **Створіть новий публічний Git-репозиторій** на GitHub, GitLab або Bitbucket (наприклад, `helm-charts-repo`).

2.  **Отримайте його HTTPS URL** (наприклад, `https://github.com/YourUsername/helm-charts-repo.git`).

3.  **Отримайте його SSH URL** (наприклад, `git@github.com:YourUsername/helm-charts-repo.git`).

4.  **Ініціалізуйте репозиторій Helm-чартів:**

### 2\. Підготовка Django Secret Key

Згенеруйте унікальний `djangoSecretKey` для вашого додатку:

```bash
# Переконайтеся, що Django встановлено у вашому віртуальному середовищі
# pip install Django

python3 -c "from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())"
```

Скопіюйте згенерований ключ.

### 3\. Оновлення змінних у Terraform та Helm-чартах

Перед застосуванням Terraform необхідно оновити всі плейсхолдери вашими актуальними значеннями.

1.  **`Project/variables.tf`**:

      * Оновіть `aws_region`, `cluster_name` та інші змінні відповідно до ваших уподобань.

2.  **`Project/main.tf`**:

      * У блоці `module "ecr"`:
          * `repository_name = "django-app-repo"`: Підтвердіть або змініть ім'я репозиторію ECR.
      * У блоці `module "argo_cd"`:
          * `helm_charts_repo_url = "https://github.com/YourUsername/helm-charts-repo.git"`: **Замініть** на HTTPS URL вашого репозиторію Helm-чартів.

3.  **`Project/charts/django-app/values.yaml`**:

      * `djangoSecretKey: "your-django-secret-key"`: **Замініть** на згенерований `djangoSecretKey`.
      * `image.repository: "your-aws-account-id.dkr.ecr.eu-central-1.amazonaws.com/django-app-repo"`: **Замініть** `your-aws-account-id` на ваш реальний 12-значний AWS Account ID. Переконайтеся, що регіон (`eu-central-1`) та ім'я репозиторію (`django-app-repo`) збігаються з вашими налаштуваннями.
      * `tag: "latest"`: Цей тег буде оновлюватися Jenkins.

4.  **`Project/django-app-repo/Jenkinsfile`**:

      * `AWS_ACCOUNT_ID = 'your-aws-account-id'`: **Замініть** на ваш 12-значний AWS Account ID.
      * `HELM_CHARTS_REPO_URL_HTTPS = 'https://github.com/YourUsername/helm-charts-repo.git'`: **Замініть** на HTTPS URL вашого репозиторію Helm-чартів.
      * `HELM_CHARTS_REPO_URL_SSH = 'git@github.com:YourUsername/helm-charts-repo.git'`: **Замініть** на SSH URL вашого репозиторію Helm-чартів.
      * `HELM_CHARTS_REPO_BRANCH = 'main'`: Переконайтеся, що це правильна гілка.
      * `credentialsId: 'your-github-ssh-key-id'`: **Замініть** на ID ваших SSH-облікових даних Jenkins (див. наступний крок).

### 4\. Налаштування Jenkins Credentials

Для того щоб Jenkins міг пушити зміни у ваш Helm-репозиторій, йому потрібні SSH-ключі:

1.  **Згенеруйте пару SSH-ключів** (якщо у вас її ще немає) на вашій локальній машині:
    ```bash
    ssh-keygen -t rsa -b 4096 -C "jenkins-charts-repo-key" -f ~/.ssh/jenkins_charts_repo_key
    ```
2.  **Додайте ПУБЛІЧНУ частину** ключа (`~/.ssh/jenkins_charts_repo_key.pub`) до вашого акаунту GitHub/GitLab/Bitbucket (Settings -\> SSH and GPG keys -\> New SSH key).
3.  **Додайте ПРИВАТНУ частину** ключа (`~/.ssh/jenkins_charts_repo_key`) до Jenkins:
      * Увійдіть до Jenkins UI (після розгортання Terraform).
      * Перейдіть до **Manage Jenkins** -\> **Manage Credentials** -\> **(global)** -\> **Add Credentials**.
      * **Kind:** "SSH Username with private key".
      * **ID:** Присвойте унікальний ID, наприклад, `github-helm-charts-ssh-key`. **Запам'ятайте цей ID\!** Це те, що ви вставите у `Jenkinsfile`.
      * **Username:** `git`.
      * **Private Key:** Оберіть "Enter directly" та вставте вміст файлу `~/.ssh/jenkins_charts_repo_key` (включаючи `-----BEGIN OPENSSH PRIVATE KEY-----` та `-----END OPENSSH PRIVATE KEY-----`).

### 5\. Застосування Terraform

Тепер ви готові застосувати Terraform:

```bash
cd Project/
terraform init                      # Ініціалізація Terraform
terraform plan                      # Перевірка плану розгортання
terraform apply -auto-approve       # Застосування змін
```

Після успішного застосування Terraform ви побачите виведення (outputs) з важливою інформацією, такою як URL Jenkins та Argo CD.

[Top :arrow_double_up:](#top)

-----

<a id="4"></a>
## Як перевірити Jenkins Job

Після того як Terraform успішно розгорне Jenkins:

1.  **Отримайте URL Jenkins:**

    ```bash
    cd Project/
    terraform output jenkins_url
    ```

    Перейдіть за цим URL у вашому браузері.

2.  **Отримайте початковий пароль адміністратора Jenkins:**

    ```bash
    kubectl -n jenkins logs $(kubectl -n jenkins get pods -l app.kubernetes.io/component=jenkins-controller -o jsonpath='{.items[0].metadata.name}') | grep 'initialAdminPassword'
    ```

    Використайте його для першого входу.

3.  **Налаштуйте Job у Jenkins:**

      * Увійдіть до Jenkins.
      * Натисніть **"New Item"** (або **"Створити елемент"**).
      * Введіть ім'я для Job (наприклад, `django-app-ci-cd`).
      * Оберіть **"Pipeline"** (Пайплайн).
      * Натисніть **"OK"**.
      * У конфігурації Job:
          * Прокрутіть до секції **"Pipeline"**.
          * **Definition:** Оберіть "Pipeline script from SCM" (Скрипт пайплайну з SCM).
          * **SCM:** "Git".
          * **Repository URL:** Вставте **HTTPS URL** вашого репозиторію з Django-додатком (який містить `Jenkinsfile`), наприклад, `https://github.com/YourUsername/django-app-repo.git`.
          * **Credentials:** Якщо ваш репозиторій з Django-додатком приватний, оберіть відповідні облікові дані. Якщо публічний, залиште `<none>`.
          * **Branches to build:** `*/main` (або ваша основна гілка).
          * **Script Path:** `Jenkinsfile` (шлях до вашого Jenkinsfile у репозиторії).
          * Натисніть **"Save"**.

4.  **Запустіть Job:**

      * Поверніться на сторінку Job.
      * Натисніть **"Build Now"** (Зібрати зараз) у лівій панелі.

5.  **Моніторинг:**

      * Слідкуйте за прогресом збірки в **"Build History"** (Історія збірок) та переглядайте **"Console Output"** (Вивід консолі) для налагодження.

Успішне виконання Job означатиме, що Docker-образ зібрано, запушено в ECR, а Helm-чарт у вашому `helm-charts-repo` оновлено новим тегом образу.

[Top :arrow_double_up:](#top)

-----

<a id="5"></a>
## Як побачити результат в Argo CD

Argo CD автоматично синхронізуватиме стан вашого додатку в кластері з Git-репозиторієм Helm-чартів.

1.  **Отримайте URL Argo CD:**

    ```bash
    cd Project/
    terraform output argo_cd_url
    ```

    Перейдіть за цим URL у вашому браузері.

2.  **Отримайте початкові облікові дані Argo CD:**

      * **Ім'я користувача:** `admin`
      * **Пароль:**
        ```bash
        kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
        ```
      * Увійдіть до Argo CD UI.

3.  **Додайте репозиторій Helm-чартів до Argo CD:**

      * В Argo CD UI перейдіть до **"Settings"** (Налаштування) -\> **"Repositories"** (Репозиторії).
      * Натисніть **"Connect Repo"** (Підключити репозиторій).
      * **Type:** `Git`.
      * **Repo URL:** Вставте **HTTPS URL** вашого репозиторію Helm-чартів (наприклад, `https://github.com/YourUsername/helm-charts-repo.git`).
      * **Private Repo:** Якщо ваш репозиторій приватний, додайте SSH-ключ або Personal Access Token тут. Для публічного репозиторію це не потрібно.
      * Натисніть **"CONNECT"**.

4.  **Створіть новий додаток Argo CD:**

      * На головній сторінці Argo CD UI натисніть **"+ NEW APP"**.
      * **Application Name:** `django-app` (або інше ім'я).
      * **Project:** `default`.
      * **Sync Policy:** `Automatic` (з опціями `Prune` та `SelfHeal`).
      * **Repository URL:** Оберіть ваш `helm-charts-repo` зі списку, що випадає.
      * **Revision:** `HEAD` (або `main`).
      * **Path:** `charts/django-app` (шлях до вашого Helm-чарту всередині репозиторію).
      * **Cluster:** `in-cluster`.
      * **Namespace:** `django-app` (або ваш простір імен).
      * Натисніть **"CREATE"**.

5.  **Моніторинг:**

      * Argo CD почне автоматично синхронізувати ваш додаток. Ви побачите його статус як `Healthy` та `Synced`, коли його буде успішно розгорнуто в кластері EKS.
      * Ви можете деталізувати додаток, щоб побачити поди, сервіси та інші ресурси Kubernetes.
      * Щоб отримати доступ до додатку, ви можете використовувати `kubectl port-forward` для сервісу або налаштувати Ingress.

[Top :arrow_double_up:](#top)

-----

<a id="6"></a>
## Очищення

Щоб видалити всі ресурси, створені Terraform:

```bash
cd Project/
terraform destroy -auto-approve
```

**Будьте обережні:** Ця команда видалить всі ресурси AWS, створені цим проєктом, включаючи кластер EKS, репозиторій ECR, Jenkins, Argo CD та всі пов'язані з ними дані.

[Top :arrow_double_up:](#top)