<a id="top"></a>

# Інфраструктура AWS за допомогою Terraform

Цей проєкт налаштовує основну інфраструктуру AWS за допомогою Terraform, включаючи S3 та DynamoDB для керування станом, Virtual Private Cloud (VPC) з публічними та приватними підмережами, а також Elastic Container Registry (ECR) для образів Docker.

<a href="#1"><img src="https://img.shields.io/badge/Структура проекту-512BD4?style=for-the-badge"/></a> <a href="#2"><img src="https://img.shields.io/badge/Пояснення модулів-ECD53F?style=for-the-badge"/></a> <a href="#3"><img src="https://img.shields.io/badge/Як розгорнути-007054?style=for-the-badge"/></a>

<a id="1"></a>

<img src="https://img.shields.io/badge/1. Структура проекту-512BD4?style=for-the-badge"/>

│
├── main.tf                  # Головний файл для підключення модулів
├── backend.tf               # Налаштування бекенду для стейтів (S3 + DynamoDB)
├── outputs.tf               # Загальне виведення ресурсів
│
├── modules/                 # Каталог з усіма модулями
│   │
│   ├── s3-backend/          # Модуль для S3 та DynamoDB
│   │   ├── s3.tf            # Створення S3-бакету
│   │   ├── dynamodb.tf      # Створення DynamoDB
│   │   ├── variables.tf     # Змінні для S3
│   │   └── outputs.tf       # Виведення інформації про S3 та DynamoDB
│   │
│   ├── vpc/                 # Модуль для VPC
│   │   ├── vpc.tf           # Створення VPC, підмереж, Internet Gateway, NAT Gateway
│   │   ├── routes.tf        # Налаштування маршрутизації
│   │   ├── variables.tf     # Змінні для VPC
│   │   └── outputs.tf       # Виведення інформації про VPC
│   │
│   └── ecr/                 # Модуль для ECR
│       ├── ecr.tf           # Створення ECR репозиторію
│       ├── variables.tf     # Змінні для ECR
│       └── outputs.tf       # Виведення URL репозиторію ECR
│
└── README.md                # Документація проєкту

[Top :arrow_double_up:](#top)

<a id="2"></a>

<img src="https://img.shields.io/badge/2. Пояснення модулів-ECD53F?style=for-the-badge"/>

### Модуль `s3-backend`

Цей модуль відповідає за налаштування бекенд-інфраструктури для керування станом Terraform.
- **S3-бакет (`s3.tf`):** Створює S3-бакет для зберігання файлів стану Terraform. Увімкнено **версіонування** для збереження історії ваших станів, а також налаштовано **шифрування** на стороні сервера для даних у стані спокою.
- **Таблиця DynamoDB (`dynamodb.tf`):** Створює таблицю DynamoDB, яка використовується для **блокування стану**. Це запобігає одночасному внесенню змін кількома користувачами Terraform до одного й того ж файлу стану, уникнення пошкоджень.

### Модуль `vpc`

Цей модуль створює основну мережеву інфраструктуру в AWS.
- **VPC (`vpc.tf`):** Визначає нову віртуальну приватну хмарну мережу із заданим CIDR-блоком.
- **Internet Gateway (`vpc.tf`):** Забезпечує підключення між вашою VPC та інтернетом, в основному для публічних підмереж.
- **Публічні підмережі (`vpc.tf`):** Створює три публічні підмережі, дозволяючи ресурсам у них мати прямий доступ до інтернету.
- **Приватні підмережі (`vpc.tf`):** Створює три приватні підмережі, призначені для ресурсів, які не повинні бути безпосередньо доступними з інтернету.
- **NAT Gateway (`vpc.tf`):** Дозволяє екземплярам у приватних підмережах ініціювати вихідні з'єднання в інтернет, залишаючись при цьому приватними.
- **Таблиці маршрутизації (`routes.tf`):** Налаштовує правила маршрутизації як для публічних, так і для приватних підмереж для належного спрямування трафіку (наприклад, публічні підмережі маршрутизуються через Internet Gateway, приватні підмережі маршрутизуються через NAT Gateway).

### Модуль `ecr`

Цей модуль налаштовує репозиторій образів Docker в AWS.
- **Репозиторій ECR (`ecr.tf`):** Створює репозиторій Elastic Container Registry (ECR) для зберігання та керування вашими образами Docker.
- **Сканування образів (`ecr.tf`):** Налаштовує репозиторій на автоматичне сканування образів на наявність вразливостей при відправленні.
- **Політика репозиторію (`ecr.tf`):** Налаштовує політику доступу для репозиторію ECR, визначаючи, хто може відправляти та отримувати образи.

[Top :arrow_double_up:](#top)

<a id="3"></a>

<img src="https://img.shields.io/badge/3. Як розгорнути-007054?style=for-the-badge"/>

Щоб розгорнути цю інфраструктуру, виконайте наступні кроки:

<a href="#4"><img src="https://img.shields.io/badge/Перейдіть до каталогу-18AEFF?style=for-the-badge"/></a>
<a href="#5"><img src="https://img.shields.io/badge/Ініціалізуйте Terraform-18AAAA?style=for-the-badge"/></a>
<a href="#6"><img src="https://img.shields.io/badge/Сплануйте розгортання-18A222?style=for-the-badge"/></a>
<a href="#7"><img src="https://img.shields.io/badge/Застосуйте зміни-18D222?style=for-the-badge"/></a>
<a href="#8"><img src="https://img.shields.io/badge/Знищення інфраструктури-A9225C?style=for-the-badge"/></a>

<a id="4"></a>

<a><img src="https://img.shields.io/badge/1-18AEFF?style=for-the-badge"/></a> **Перейдіть до каталогу `name`:**
    ```bash
    cd <name>
    ```

<a id="5"></a>

<a><img src="https://img.shields.io/badge/2-18AAAA?style=for-the-badge"/></a> **Ініціалізуйте Terraform:**
    Ця команда ініціалізує робочий каталог, завантажує необхідні провайдери та налаштовує бекенд S3 для синхронізації стану.
    ```bash
    terraform init
    ```
    **Важливо:** Після першого запуску `terraform init` Terraform створить S3-бакет та таблицю DynamoDB. Для подальших запусків ці ресурси вже існуватимуть, і Terraform використовуватиме їх.

    Результат в терміналі:
    ```bash
    $ terraform init
    Initializing the backend...

    Successfully configured the backend "s3"! Terraform will automatically
    use this backend unless the backend configuration changes.
    Initializing modules...
    Initializing provider plugins...
    - Finding latest version of hashicorp/aws...
    - Installing hashicorp/aws v6.2.0...
    - Installed hashicorp/aws v6.2.0 (signed by HashiCorp)
    Terraform has created a lock file .terraform.lock.hcl to record the provider
    selections it made above. Include this file in your version control repository
    so that Terraform can guarantee to make the same selections by default when
    you run "terraform init" in the future.

    Terraform has been successfully initialized!

    You may now begin working with Terraform. Try running "terraform plan" to see
    any changes that are required for your infrastructure. All Terraform commands
    should now work.

    If you ever set or change modules or backend configuration for Terraform,
    rerun this command to reinitialize your working directory. If you forget, other
    commands will detect it and remind you to do so if necessary.
    ```
[Top :arrow_double_up:](#top)

<a id="6"></a>

<a><img src="https://img.shields.io/badge/3-18A222?style=for-the-badge"/></a> **Сплануйте розгортання:**
    Ця команда показує, що Terraform буде робити, не вносячи жодних змін. Це гарний спосіб переглянути план перед застосуванням.
    ```bash
    terraform plan
    ```
    Результат в терміналі:
    ```bash
    $ terraform plan
    module.ecr.data.aws_caller_identity.current: Reading...
    module.ecr.data.aws_caller_identity.current: Read complete after 0s [id=152710746299]

    Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
    + create

    Terraform will perform the following actions:

    # module.ecr.aws_ecr_repository.main will be created
    + resource "aws_ecr_repository" "main" {
        + arn                  = (known after apply)
        + id                   = (known after apply)
        + image_tag_mutability = "MUTABLE"
        + name                 = "lesson-5-ecr"
        + region               = "eu-central-1"
        + registry_id          = (known after apply)
        + repository_url       = (known after apply)
        + tags                 = {
            + "Name" = "lesson-5-ecr"
            }
        + tags_all             = {
            + "Name" = "lesson-5-ecr"
            }

        + image_scanning_configuration {
            + scan_on_push = true
            }
        }

    # module.ecr.aws_ecr_repository_policy.main_policy will be created
    + resource "aws_ecr_repository_policy" "main_policy" {
        + id          = (known after apply)
        + policy      = jsonencode(
                {
                + Statement = [
                    + {
                        + Action    = [
                            + "ecr:GetDownloadUrlForLayer",
                            + "ecr:BatchGetImage",
                            + "ecr:BatchCheckLayerAvailability",
                            + "ecr:PutImage",
                            + "ecr:InitiateLayerUpload",
                            + "ecr:UploadLayerPart",
                            + "ecr:CompleteLayerUpload",
                            + "ecr:DescribeRepositories",
                            + "ecr:GetRepositoryPolicy",
                            + "ecr:ListImages",
                            + "ecr:DeleteRepository",
                            + "ecr:BatchDeleteImage",
                            + "ecr:SetRepositoryPolicy",
                            + "ecr:DeleteRepositoryPolicy",
                            ]
                        + Effect    = "Allow"
                        + Principal = {
                            + AWS = "arn:aws:iam::152710746299:root"
                            }
                        + Sid       = "AllowPushPull"
                        },
                    ]
                + Version   = "2008-10-17"
                }
            )
        + region      = "eu-central-1"
        + registry_id = (known after apply)
        + repository  = "lesson-5-ecr"
        }

    # module.s3_backend.aws_dynamodb_table.terraform_locks will be created
    + resource "aws_dynamodb_table" "terraform_locks" {
        + arn              = (known after apply)
        + billing_mode     = "PAY_PER_REQUEST"
        + hash_key         = "LockID"
        + id               = (known after apply)
        + name             = "terraform-locks"
        + read_capacity    = (known after apply)
        + region           = "eu-central-1"
        + stream_arn       = (known after apply)
        + stream_label     = (known after apply)
        + stream_view_type = (known after apply)
        + tags             = {
            + "Environment" = "Dev"
            + "Name"        = "terraform-locks-lock"
            }
        + tags_all         = {
            + "Environment" = "Dev"
            + "Name"        = "terraform-locks-lock"
            }
        + write_capacity   = (known after apply)

        + attribute {
            + name = "LockID"
            + type = "S"
            }

        + point_in_time_recovery (known after apply)

        + server_side_encryption (known after apply)

        + ttl (known after apply)
        }

    # module.s3_backend.aws_s3_bucket.terraform_state will be created
    + resource "aws_s3_bucket" "terraform_state" {
        + acceleration_status         = (known after apply)
        + acl                         = (known after apply)
        + arn                         = (known after apply)
        + bucket                      = "tf-state-aleksey-goit-2025-07-08"
        + bucket_domain_name          = (known after apply)
        + bucket_prefix               = (known after apply)
        + bucket_region               = (known after apply)
        + bucket_regional_domain_name = (known after apply)
        + force_destroy               = false
        + hosted_zone_id              = (known after apply)
        + id                          = (known after apply)
        + object_lock_enabled         = (known after apply)
        + policy                      = (known after apply)
        + region                      = "eu-central-1"
        + request_payer               = (known after apply)
        + tags                        = {
            + "Environment" = "Dev"
            + "Name"        = "tf-state-aleksey-goit-2025-07-08-tfstate"
            }
        + tags_all                    = {
            + "Environment" = "Dev"
            + "Name"        = "tf-state-aleksey-goit-2025-07-08-tfstate"
            }
        + website_domain              = (known after apply)
        + website_endpoint            = (known after apply)

        + cors_rule (known after apply)

        + grant (known after apply)

        + lifecycle_rule (known after apply)

        + logging (known after apply)

        + object_lock_configuration (known after apply)

        + replication_configuration (known after apply)

        + server_side_encryption_configuration (known after apply)

        + versioning (known after apply)

        + website (known after apply)
        }

    # module.s3_backend.aws_s3_bucket_acl.terraform_state_acl will be created
    + resource "aws_s3_bucket_acl" "terraform_state_acl" {
        + acl    = "private"
        + bucket = (known after apply)
        + id     = (known after apply)
        + region = "eu-central-1"

        + access_control_policy (known after apply)
        }

    # module.s3_backend.aws_s3_bucket_server_side_encryption_configuration.terraform_state_sse will be created
    + resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_sse" {
        + bucket = (known after apply)
        + id     = (known after apply)
        + region = "eu-central-1"

        + rule {
            + apply_server_side_encryption_by_default {
                + sse_algorithm     = "AES256"
                    # (1 unchanged attribute hidden)
                }
            }
        }

    # module.s3_backend.aws_s3_bucket_versioning.terraform_state_versioning will be created
    + resource "aws_s3_bucket_versioning" "terraform_state_versioning" {
        + bucket = (known after apply)
        + id     = (known after apply)
        + region = "eu-central-1"

        + versioning_configuration {
            + mfa_delete = (known after apply)
            + status     = "Enabled"
            }
        }

    # module.vpc.aws_eip.nat_gateway_eip[0] will be created
    + resource "aws_eip" "nat_gateway_eip" {
        + allocation_id        = (known after apply)
        + arn                  = (known after apply)
        + association_id       = (known after apply)
        + carrier_ip           = (known after apply)
        + customer_owned_ip    = (known after apply)
        + domain               = (known after apply)
        + id                   = (known after apply)
        + instance             = (known after apply)
        + ipam_pool_id         = (known after apply)
        + network_border_group = (known after apply)
        + network_interface    = (known after apply)
        + private_dns          = (known after apply)
        + private_ip           = (known after apply)
        + ptr_record           = (known after apply)
        + public_dns           = (known after apply)
        + public_ip            = (known after apply)
        + public_ipv4_pool     = (known after apply)
        + region               = "eu-central-1"
        + tags                 = {
            + "Name" = "lesson-5-vpc-nat-eip-1"
            }
        + tags_all             = {
            + "Name" = "lesson-5-vpc-nat-eip-1"
            }
        }

    # module.vpc.aws_eip.nat_gateway_eip[1] will be created
    + resource "aws_eip" "nat_gateway_eip" {
        + allocation_id        = (known after apply)
        + arn                  = (known after apply)
        + association_id       = (known after apply)
        + carrier_ip           = (known after apply)
        + customer_owned_ip    = (known after apply)
        + domain               = (known after apply)
        + id                   = (known after apply)
        + instance             = (known after apply)
        + ipam_pool_id         = (known after apply)
        + network_border_group = (known after apply)
        + network_interface    = (known after apply)
        + private_dns          = (known after apply)
        + private_ip           = (known after apply)
        + ptr_record           = (known after apply)
        + public_dns           = (known after apply)
        + public_ip            = (known after apply)
        + public_ipv4_pool     = (known after apply)
        + region               = "eu-central-1"
        + tags                 = {
            + "Name" = "lesson-5-vpc-nat-eip-2"
            }
        + tags_all             = {
            + "Name" = "lesson-5-vpc-nat-eip-2"
            }
        }

    # module.vpc.aws_eip.nat_gateway_eip[2] will be created
    + resource "aws_eip" "nat_gateway_eip" {
        + allocation_id        = (known after apply)
        + arn                  = (known after apply)
        + association_id       = (known after apply)
        + carrier_ip           = (known after apply)
        + customer_owned_ip    = (known after apply)
        + domain               = (known after apply)
        + id                   = (known after apply)
        + instance             = (known after apply)
        + ipam_pool_id         = (known after apply)
        + network_border_group = (known after apply)
        + network_interface    = (known after apply)
        + private_dns          = (known after apply)
        + private_ip           = (known after apply)
        + ptr_record           = (known after apply)
        + public_dns           = (known after apply)
        + public_ip            = (known after apply)
        + public_ipv4_pool     = (known after apply)
        + region               = "eu-central-1"
        + tags                 = {
            + "Name" = "lesson-5-vpc-nat-eip-3"
            }
        + tags_all             = {
            + "Name" = "lesson-5-vpc-nat-eip-3"
            }
        }

    # module.vpc.aws_internet_gateway.gw will be created
    + resource "aws_internet_gateway" "gw" {
        + arn      = (known after apply)
        + id       = (known after apply)
        + owner_id = (known after apply)
        + region   = "eu-central-1"
        + tags     = {
            + "Name" = "lesson-5-vpc-igw"
            }
        + tags_all = {
            + "Name" = "lesson-5-vpc-igw"
            }
        + vpc_id   = (known after apply)
        }

    # module.vpc.aws_nat_gateway.nat_gateway[0] will be created
    + resource "aws_nat_gateway" "nat_gateway" {
        + allocation_id                      = (known after apply)
        + association_id                     = (known after apply)
        + connectivity_type                  = "public"
        + id                                 = (known after apply)
        + network_interface_id               = (known after apply)
        + private_ip                         = (known after apply)
        + public_ip                          = (known after apply)
        + region                             = "eu-central-1"
        + secondary_private_ip_address_count = (known after apply)
        + secondary_private_ip_addresses     = (known after apply)
        + subnet_id                          = (known after apply)
        + tags                               = {
            + "Name" = "lesson-5-vpc-nat-gateway-1"
            }
        + tags_all                           = {
            + "Name" = "lesson-5-vpc-nat-gateway-1"
            }
        }

    # module.vpc.aws_nat_gateway.nat_gateway[1] will be created
    + resource "aws_nat_gateway" "nat_gateway" {
        + allocation_id                      = (known after apply)
        + association_id                     = (known after apply)
        + connectivity_type                  = "public"
        + id                                 = (known after apply)
        + network_interface_id               = (known after apply)
        + private_ip                         = (known after apply)
        + public_ip                          = (known after apply)
        + region                             = "eu-central-1"
        + secondary_private_ip_address_count = (known after apply)
        + secondary_private_ip_addresses     = (known after apply)
        + subnet_id                          = (known after apply)
        + tags                               = {
            + "Name" = "lesson-5-vpc-nat-gateway-2"
            }
        + tags_all                           = {
            + "Name" = "lesson-5-vpc-nat-gateway-2"
            }
        }

    # module.vpc.aws_nat_gateway.nat_gateway[2] will be created
    + resource "aws_nat_gateway" "nat_gateway" {
        + allocation_id                      = (known after apply)
        + association_id                     = (known after apply)
        + connectivity_type                  = "public"
        + id                                 = (known after apply)
        + network_interface_id               = (known after apply)
        + private_ip                         = (known after apply)
        + public_ip                          = (known after apply)
        + region                             = "eu-central-1"
        + secondary_private_ip_address_count = (known after apply)
        + secondary_private_ip_addresses     = (known after apply)
        + subnet_id                          = (known after apply)
        + tags                               = {
            + "Name" = "lesson-5-vpc-nat-gateway-3"
            }
        + tags_all                           = {
            + "Name" = "lesson-5-vpc-nat-gateway-3"
            }
        }

    # module.vpc.aws_route_table.private[0] will be created
    + resource "aws_route_table" "private" {
        + arn              = (known after apply)
        + id               = (known after apply)
        + owner_id         = (known after apply)
        + propagating_vgws = (known after apply)
        + region           = "eu-central-1"
        + route            = [
            + {
                + cidr_block                 = "0.0.0.0/0"
                + nat_gateway_id             = (known after apply)
                    # (11 unchanged attributes hidden)
                },
            ]
        + tags             = {
            + "Name" = "lesson-5-vpc-private-rt-1"
            }
        + tags_all         = {
            + "Name" = "lesson-5-vpc-private-rt-1"
            }
        + vpc_id           = (known after apply)
        }

    # module.vpc.aws_route_table.private[1] will be created
    + resource "aws_route_table" "private" {
        + arn              = (known after apply)
        + id               = (known after apply)
        + owner_id         = (known after apply)
        + propagating_vgws = (known after apply)
        + region           = "eu-central-1"
        + route            = [
            + {
                + cidr_block                 = "0.0.0.0/0"
                + nat_gateway_id             = (known after apply)
                    # (11 unchanged attributes hidden)
                },
            ]
        + tags             = {
            + "Name" = "lesson-5-vpc-private-rt-2"
            }
        + tags_all         = {
            + "Name" = "lesson-5-vpc-private-rt-2"
            }
        + vpc_id           = (known after apply)
        }

    # module.vpc.aws_route_table.private[2] will be created
    + resource "aws_route_table" "private" {
        + arn              = (known after apply)
        + id               = (known after apply)
        + owner_id         = (known after apply)
        + propagating_vgws = (known after apply)
        + region           = "eu-central-1"
        + route            = [
            + {
                + cidr_block                 = "0.0.0.0/0"
                + nat_gateway_id             = (known after apply)
                    # (11 unchanged attributes hidden)
                },
            ]
        + tags             = {
            + "Name" = "lesson-5-vpc-private-rt-3"
            }
        + tags_all         = {
            + "Name" = "lesson-5-vpc-private-rt-3"
            }
        + vpc_id           = (known after apply)
        }

    # module.vpc.aws_route_table.public will be created
    + resource "aws_route_table" "public" {
        + arn              = (known after apply)
        + id               = (known after apply)
        + owner_id         = (known after apply)
        + propagating_vgws = (known after apply)
        + region           = "eu-central-1"
        + route            = [
            + {
                + cidr_block                 = "0.0.0.0/0"
                + gateway_id                 = (known after apply)
                    # (11 unchanged attributes hidden)
                },
            ]
        + tags             = {
            + "Name" = "lesson-5-vpc-public-rt"
            }
        + tags_all         = {
            + "Name" = "lesson-5-vpc-public-rt"
            }
        + vpc_id           = (known after apply)
        }

    # module.vpc.aws_route_table_association.private[0] will be created
    + resource "aws_route_table_association" "private" {
        + id             = (known after apply)
        + region         = "eu-central-1"
        + route_table_id = (known after apply)
        + subnet_id      = (known after apply)
        }

    # module.vpc.aws_route_table_association.private[1] will be created
    + resource "aws_route_table_association" "private" {
        + id             = (known after apply)
        + region         = "eu-central-1"
        + route_table_id = (known after apply)
        + subnet_id      = (known after apply)
        }

    # module.vpc.aws_route_table_association.private[2] will be created
    + resource "aws_route_table_association" "private" {
        + id             = (known after apply)
        + region         = "eu-central-1"
        + route_table_id = (known after apply)
        + subnet_id      = (known after apply)
        }

    # module.vpc.aws_route_table_association.public[0] will be created
    + resource "aws_route_table_association" "public" {
        + id             = (known after apply)
        + region         = "eu-central-1"
        + route_table_id = (known after apply)
        + subnet_id      = (known after apply)
        }

    # module.vpc.aws_route_table_association.public[1] will be created
    + resource "aws_route_table_association" "public" {
        + id             = (known after apply)
        + region         = "eu-central-1"
        + route_table_id = (known after apply)
        + subnet_id      = (known after apply)
        }

    # module.vpc.aws_route_table_association.public[2] will be created
    + resource "aws_route_table_association" "public" {
        + id             = (known after apply)
        + region         = "eu-central-1"
        + route_table_id = (known after apply)
        + subnet_id      = (known after apply)
        }

    # module.vpc.aws_subnet.private[0] will be created
    + resource "aws_subnet" "private" {
        + arn                                            = (known after apply)
        + assign_ipv6_address_on_creation                = false
        + availability_zone                              = "eu-central-1a"
        + availability_zone_id                           = (known after apply)
        + cidr_block                                     = "10.0.4.0/24"
        + enable_dns64                                   = false
        + enable_resource_name_dns_a_record_on_launch    = false
        + enable_resource_name_dns_aaaa_record_on_launch = false
        + id                                             = (known after apply)
        + ipv6_cidr_block_association_id                 = (known after apply)
        + ipv6_native                                    = false
        + map_public_ip_on_launch                        = false
        + owner_id                                       = (known after apply)
        + private_dns_hostname_type_on_launch            = (known after apply)
        + region                                         = "eu-central-1"
        + tags                                           = {
            + "Name" = "lesson-5-vpc-private-subnet-1"
            }
        + tags_all                                       = {
            + "Name" = "lesson-5-vpc-private-subnet-1"
            }
        + vpc_id                                         = (known after apply)
        }

    # module.vpc.aws_subnet.private[1] will be created
    + resource "aws_subnet" "private" {
        + arn                                            = (known after apply)
        + assign_ipv6_address_on_creation                = false
        + availability_zone                              = "eu-central-1b"
        + availability_zone_id                           = (known after apply)
        + cidr_block                                     = "10.0.5.0/24"
        + enable_dns64                                   = false
        + enable_resource_name_dns_a_record_on_launch    = false
        + enable_resource_name_dns_aaaa_record_on_launch = false
        + id                                             = (known after apply)
        + ipv6_cidr_block_association_id                 = (known after apply)
        + ipv6_native                                    = false
        + map_public_ip_on_launch                        = false
        + owner_id                                       = (known after apply)
        + private_dns_hostname_type_on_launch            = (known after apply)
        + region                                         = "eu-central-1"
        + tags                                           = {
            + "Name" = "lesson-5-vpc-private-subnet-2"
            }
        + tags_all                                       = {
            + "Name" = "lesson-5-vpc-private-subnet-2"
            }
        + vpc_id                                         = (known after apply)
        }

    # module.vpc.aws_subnet.private[2] will be created
    + resource "aws_subnet" "private" {
        + arn                                            = (known after apply)
        + assign_ipv6_address_on_creation                = false
        + availability_zone                              = "eu-central-1c"
        + availability_zone_id                           = (known after apply)
        + cidr_block                                     = "10.0.6.0/24"
        + enable_dns64                                   = false
        + enable_resource_name_dns_a_record_on_launch    = false
        + enable_resource_name_dns_aaaa_record_on_launch = false
        + id                                             = (known after apply)
        + ipv6_cidr_block_association_id                 = (known after apply)
        + ipv6_native                                    = false
        + map_public_ip_on_launch                        = false
        + owner_id                                       = (known after apply)
        + private_dns_hostname_type_on_launch            = (known after apply)
        + region                                         = "eu-central-1"
        + tags                                           = {
            + "Name" = "lesson-5-vpc-private-subnet-3"
            }
        + tags_all                                       = {
            + "Name" = "lesson-5-vpc-private-subnet-3"
            }
        + vpc_id                                         = (known after apply)
        }

    # module.vpc.aws_subnet.public[0] will be created
    + resource "aws_subnet" "public" {
        + arn                                            = (known after apply)
        + assign_ipv6_address_on_creation                = false
        + availability_zone                              = "eu-central-1a"
        + availability_zone_id                           = (known after apply)
        + cidr_block                                     = "10.0.1.0/24"
        + enable_dns64                                   = false
        + enable_resource_name_dns_a_record_on_launch    = false
        + enable_resource_name_dns_aaaa_record_on_launch = false
        + id                                             = (known after apply)
        + ipv6_cidr_block_association_id                 = (known after apply)
        + ipv6_native                                    = false
        + map_public_ip_on_launch                        = true
        + owner_id                                       = (known after apply)
        + private_dns_hostname_type_on_launch            = (known after apply)
        + region                                         = "eu-central-1"
        + tags                                           = {
            + "Name" = "lesson-5-vpc-public-subnet-1"
            }
        + tags_all                                       = {
            + "Name" = "lesson-5-vpc-public-subnet-1"
            }
        + vpc_id                                         = (known after apply)
        }

    # module.vpc.aws_subnet.public[1] will be created
    + resource "aws_subnet" "public" {
        + arn                                            = (known after apply)
        + assign_ipv6_address_on_creation                = false
        + availability_zone                              = "eu-central-1b"
        + availability_zone_id                           = (known after apply)
        + cidr_block                                     = "10.0.2.0/24"
        + enable_dns64                                   = false
        + enable_resource_name_dns_a_record_on_launch    = false
        + enable_resource_name_dns_aaaa_record_on_launch = false
        + id                                             = (known after apply)
        + ipv6_cidr_block_association_id                 = (known after apply)
        + ipv6_native                                    = false
        + map_public_ip_on_launch                        = true
        + owner_id                                       = (known after apply)
        + private_dns_hostname_type_on_launch            = (known after apply)
        + region                                         = "eu-central-1"
        + tags                                           = {
            + "Name" = "lesson-5-vpc-public-subnet-2"
            }
        + tags_all                                       = {
            + "Name" = "lesson-5-vpc-public-subnet-2"
            }
        + vpc_id                                         = (known after apply)
        }

    # module.vpc.aws_subnet.public[2] will be created
    + resource "aws_subnet" "public" {
        + arn                                            = (known after apply)
        + assign_ipv6_address_on_creation                = false
        + availability_zone                              = "eu-central-1c"
        + availability_zone_id                           = (known after apply)
        + cidr_block                                     = "10.0.3.0/24"
        + enable_dns64                                   = false
        + enable_resource_name_dns_a_record_on_launch    = false
        + enable_resource_name_dns_aaaa_record_on_launch = false
        + id                                             = (known after apply)
        + ipv6_cidr_block_association_id                 = (known after apply)
        + ipv6_native                                    = false
        + map_public_ip_on_launch                        = true
        + owner_id                                       = (known after apply)
        + private_dns_hostname_type_on_launch            = (known after apply)
        + region                                         = "eu-central-1"
        + tags                                           = {
            + "Name" = "lesson-5-vpc-public-subnet-3"
            }
        + tags_all                                       = {
            + "Name" = "lesson-5-vpc-public-subnet-3"
            }
        + vpc_id                                         = (known after apply)
        }

    # module.vpc.aws_vpc.main will be created
    + resource "aws_vpc" "main" {
        + arn                                  = (known after apply)
        + cidr_block                           = "10.0.0.0/16"
        + default_network_acl_id               = (known after apply)
        + default_route_table_id               = (known after apply)
        + default_security_group_id            = (known after apply)
        + dhcp_options_id                      = (known after apply)
        + enable_dns_hostnames                 = true
        + enable_dns_support                   = true
        + enable_network_address_usage_metrics = (known after apply)
        + id                                   = (known after apply)
        + instance_tenancy                     = "default"
        + ipv6_association_id                  = (known after apply)
        + ipv6_cidr_block                      = (known after apply)
        + ipv6_cidr_block_network_border_group = (known after apply)
        + main_route_table_id                  = (known after apply)
        + owner_id                             = (known after apply)
        + region                               = "eu-central-1"
        + tags                                 = {
            + "Name" = "lesson-5-vpc"
            }
        + tags_all                             = {
            + "Name" = "lesson-5-vpc"
            }
        }

    Plan: 31 to add, 0 to change, 0 to destroy.

    Changes to Outputs:
    + dynamodb_table_name = "terraform-locks"
    + ecr_repository_url  = (known after apply)
    + private_subnet_ids  = [
        + (known after apply),
        + (known after apply),
        + (known after apply),
        ]
    + public_subnet_ids   = [
        + (known after apply),
        + (known after apply),
        + (known after apply),
        ]
    + s3_bucket_url       = "s3://tf-state-aleksey-goit-2025-07-08"
    + vpc_id              = (known after apply)

    ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

    Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
    ```
[Top :arrow_double_up:](#top)

<a id="7"></a>

<a><img src="https://img.shields.io/badge/4-18D222?style=for-the-badge"/></a> **Застосуйте зміни:**
    Ця команда застосовує заплановані зміни та створює ресурси AWS. Вам буде запропоновано підтвердити дію.
    ```bash
    terraform apply
    ```
    Результат в терміналі:
    ```bash
    $ terraform apply
    module.ecr.data.aws_caller_identity.current: Reading...
    module.ecr.data.aws_caller_identity.current: Read complete after 0s [id=152710746299]

    Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
    + create

    Terraform will perform the following actions:

    # module.ecr.aws_ecr_repository.main will be created
    + resource "aws_ecr_repository" "main" {
        + arn                  = (known after apply)
        + id                   = (known after apply)
        + image_tag_mutability = "MUTABLE"
        + name                 = "lesson-5-ecr"
        + region               = "eu-central-1"
        + registry_id          = (known after apply)
        + repository_url       = (known after apply)
        + tags                 = {
            + "Name" = "lesson-5-ecr"
            }
        + tags_all             = {
            + "Name" = "lesson-5-ecr"
            }

        + image_scanning_configuration {
            + scan_on_push = true
            }
        }

    # module.ecr.aws_ecr_repository_policy.main_policy will be created
    + resource "aws_ecr_repository_policy" "main_policy" {
        + id          = (known after apply)
        + policy      = jsonencode(
                {
                + Statement = [
                    + {
                        + Action    = [
                            + "ecr:GetDownloadUrlForLayer",
                            + "ecr:BatchGetImage",
                            + "ecr:BatchCheckLayerAvailability",
                            + "ecr:PutImage",
                            + "ecr:InitiateLayerUpload",
                            + "ecr:UploadLayerPart",
                            + "ecr:CompleteLayerUpload",
                            + "ecr:DescribeRepositories",
                            + "ecr:GetRepositoryPolicy",
                            + "ecr:ListImages",
                            + "ecr:DeleteRepository",
                            + "ecr:BatchDeleteImage",
                            + "ecr:SetRepositoryPolicy",
                            + "ecr:DeleteRepositoryPolicy",
                            ]
                        + Effect    = "Allow"
                        + Principal = {
                            + AWS = "arn:aws:iam::152710746299:root"
                            }
                        + Sid       = "AllowPushPull"
                        },
                    ]
                + Version   = "2008-10-17"
                }
            )
        + region      = "eu-central-1"
        + registry_id = (known after apply)
        + repository  = "lesson-5-ecr"
        }

    # module.s3_backend.aws_dynamodb_table.terraform_locks will be created
    + resource "aws_dynamodb_table" "terraform_locks" {
        + arn              = (known after apply)
        + billing_mode     = "PAY_PER_REQUEST"
        + hash_key         = "LockID"
        + id               = (known after apply)
        + name             = "terraform-locks"
        + read_capacity    = (known after apply)
        + region           = "eu-central-1"
        + stream_arn       = (known after apply)
        + stream_label     = (known after apply)
        + stream_view_type = (known after apply)
        + tags             = {
            + "Environment" = "Dev"
            + "Name"        = "terraform-locks-lock"
            }
        + tags_all         = {
            + "Environment" = "Dev"
            + "Name"        = "terraform-locks-lock"
            }
        + write_capacity   = (known after apply)

        + attribute {
            + name = "LockID"
            + type = "S"
            }

        + point_in_time_recovery (known after apply)

        + server_side_encryption (known after apply)

        + ttl (known after apply)
        }

    # module.s3_backend.aws_s3_bucket.terraform_state will be created
    + resource "aws_s3_bucket" "terraform_state" {
        + acceleration_status         = (known after apply)
        + acl                         = (known after apply)
        + arn                         = (known after apply)
        + bucket                      = "tf-state-aleksey-goit-2025-07-08"
        + bucket_domain_name          = (known after apply)
        + bucket_prefix               = (known after apply)
        + bucket_region               = (known after apply)
        + bucket_regional_domain_name = (known after apply)
        + force_destroy               = false
        + hosted_zone_id              = (known after apply)
        + id                          = (known after apply)
        + object_lock_enabled         = (known after apply)
        + policy                      = (known after apply)
        + region                      = "eu-central-1"
        + request_payer               = (known after apply)
        + tags                        = {
            + "Environment" = "Dev"
            + "Name"        = "tf-state-aleksey-goit-2025-07-08-tfstate"
            }
        + tags_all                    = {
            + "Environment" = "Dev"
            + "Name"        = "tf-state-aleksey-goit-2025-07-08-tfstate"
            }
        + website_domain              = (known after apply)
        + website_endpoint            = (known after apply)

        + cors_rule (known after apply)

        + grant (known after apply)

        + lifecycle_rule (known after apply)

        + logging (known after apply)

        + object_lock_configuration (known after apply)

        + replication_configuration (known after apply)

        + server_side_encryption_configuration (known after apply)

        + versioning (known after apply)

        + website (known after apply)
        }

    # module.s3_backend.aws_s3_bucket_acl.terraform_state_acl will be created
    + resource "aws_s3_bucket_acl" "terraform_state_acl" {
        + acl    = "private"
        + bucket = (known after apply)
        + id     = (known after apply)
        + region = "eu-central-1"

        + access_control_policy (known after apply)
        }

    # module.s3_backend.aws_s3_bucket_server_side_encryption_configuration.terraform_state_sse will be created
    + resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_sse" {
        + bucket = (known after apply)
        + id     = (known after apply)
        + region = "eu-central-1"

        + rule {
            + apply_server_side_encryption_by_default {
                + sse_algorithm     = "AES256"
                    # (1 unchanged attribute hidden)
                }
            }
        }

    # module.s3_backend.aws_s3_bucket_versioning.terraform_state_versioning will be created
    + resource "aws_s3_bucket_versioning" "terraform_state_versioning" {
        + bucket = (known after apply)
        + id     = (known after apply)
        + region = "eu-central-1"

        + versioning_configuration {
            + mfa_delete = (known after apply)
            + status     = "Enabled"
            }
        }

    # module.vpc.aws_eip.nat_gateway_eip[0] will be created
    + resource "aws_eip" "nat_gateway_eip" {
        + allocation_id        = (known after apply)
        + arn                  = (known after apply)
        + association_id       = (known after apply)
        + carrier_ip           = (known after apply)
        + customer_owned_ip    = (known after apply)
        + domain               = (known after apply)
        + id                   = (known after apply)
        + instance             = (known after apply)
        + ipam_pool_id         = (known after apply)
        + network_border_group = (known after apply)
        + network_interface    = (known after apply)
        + private_dns          = (known after apply)
        + private_ip           = (known after apply)
        + ptr_record           = (known after apply)
        + public_dns           = (known after apply)
        + public_ip            = (known after apply)
        + public_ipv4_pool     = (known after apply)
        + region               = "eu-central-1"
        + tags                 = {
            + "Name" = "lesson-5-vpc-nat-eip-1"
            }
        + tags_all             = {
            + "Name" = "lesson-5-vpc-nat-eip-1"
            }
        }

    # module.vpc.aws_eip.nat_gateway_eip[1] will be created
    + resource "aws_eip" "nat_gateway_eip" {
        + allocation_id        = (known after apply)
        + arn                  = (known after apply)
        + association_id       = (known after apply)
        + carrier_ip           = (known after apply)
        + customer_owned_ip    = (known after apply)
        + domain               = (known after apply)
        + id                   = (known after apply)
        + instance             = (known after apply)
        + ipam_pool_id         = (known after apply)
        + network_border_group = (known after apply)
        + network_interface    = (known after apply)
        + private_dns          = (known after apply)
        + private_ip           = (known after apply)
        + ptr_record           = (known after apply)
        + public_dns           = (known after apply)
        + public_ip            = (known after apply)
        + public_ipv4_pool     = (known after apply)
        + region               = "eu-central-1"
        + tags                 = {
            + "Name" = "lesson-5-vpc-nat-eip-2"
            }
        + tags_all             = {
            + "Name" = "lesson-5-vpc-nat-eip-2"
            }
        }

    # module.vpc.aws_eip.nat_gateway_eip[2] will be created
    + resource "aws_eip" "nat_gateway_eip" {
        + allocation_id        = (known after apply)
        + arn                  = (known after apply)
        + association_id       = (known after apply)
        + carrier_ip           = (known after apply)
        + customer_owned_ip    = (known after apply)
        + domain               = (known after apply)
        + id                   = (known after apply)
        + instance             = (known after apply)
        + ipam_pool_id         = (known after apply)
        + network_border_group = (known after apply)
        + network_interface    = (known after apply)
        + private_dns          = (known after apply)
        + private_ip           = (known after apply)
        + ptr_record           = (known after apply)
        + public_dns           = (known after apply)
        + public_ip            = (known after apply)
        + public_ipv4_pool     = (known after apply)
        + region               = "eu-central-1"
        + tags                 = {
            + "Name" = "lesson-5-vpc-nat-eip-3"
            }
        + tags_all             = {
            + "Name" = "lesson-5-vpc-nat-eip-3"
            }
        }

    # module.vpc.aws_internet_gateway.gw will be created
    + resource "aws_internet_gateway" "gw" {
        + arn      = (known after apply)
        + id       = (known after apply)
        + owner_id = (known after apply)
        + region   = "eu-central-1"
        + tags     = {
            + "Name" = "lesson-5-vpc-igw"
            }
        + tags_all = {
            + "Name" = "lesson-5-vpc-igw"
            }
        + vpc_id   = (known after apply)
        }

    # module.vpc.aws_nat_gateway.nat_gateway[0] will be created
    + resource "aws_nat_gateway" "nat_gateway" {
        + allocation_id                      = (known after apply)
        + association_id                     = (known after apply)
        + connectivity_type                  = "public"
        + id                                 = (known after apply)
        + network_interface_id               = (known after apply)
        + private_ip                         = (known after apply)
        + public_ip                          = (known after apply)
        + region                             = "eu-central-1"
        + secondary_private_ip_address_count = (known after apply)
        + secondary_private_ip_addresses     = (known after apply)
        + subnet_id                          = (known after apply)
        + tags                               = {
            + "Name" = "lesson-5-vpc-nat-gateway-1"
            }
        + tags_all                           = {
            + "Name" = "lesson-5-vpc-nat-gateway-1"
            }
        }

    # module.vpc.aws_nat_gateway.nat_gateway[1] will be created
    + resource "aws_nat_gateway" "nat_gateway" {
        + allocation_id                      = (known after apply)
        + association_id                     = (known after apply)
        + connectivity_type                  = "public"
        + id                                 = (known after apply)
        + network_interface_id               = (known after apply)
        + private_ip                         = (known after apply)
        + public_ip                          = (known after apply)
        + region                             = "eu-central-1"
        + secondary_private_ip_address_count = (known after apply)
        + secondary_private_ip_addresses     = (known after apply)
        + subnet_id                          = (known after apply)
        + tags                               = {
            + "Name" = "lesson-5-vpc-nat-gateway-2"
            }
        + tags_all                           = {
            + "Name" = "lesson-5-vpc-nat-gateway-2"
            }
        }

    # module.vpc.aws_nat_gateway.nat_gateway[2] will be created
    + resource "aws_nat_gateway" "nat_gateway" {
        + allocation_id                      = (known after apply)
        + association_id                     = (known after apply)
        + connectivity_type                  = "public"
        + id                                 = (known after apply)
        + network_interface_id               = (known after apply)
        + private_ip                         = (known after apply)
        + public_ip                          = (known after apply)
        + region                             = "eu-central-1"
        + secondary_private_ip_address_count = (known after apply)
        + secondary_private_ip_addresses     = (known after apply)
        + subnet_id                          = (known after apply)
        + tags                               = {
            + "Name" = "lesson-5-vpc-nat-gateway-3"
            }
        + tags_all                           = {
            + "Name" = "lesson-5-vpc-nat-gateway-3"
            }
        }

    # module.vpc.aws_route_table.private[0] will be created
    + resource "aws_route_table" "private" {
        + arn              = (known after apply)
        + id               = (known after apply)
        + owner_id         = (known after apply)
        + propagating_vgws = (known after apply)
        + region           = "eu-central-1"
        + route            = [
            + {
                + cidr_block                 = "0.0.0.0/0"
                + nat_gateway_id             = (known after apply)
                    # (11 unchanged attributes hidden)
                },
            ]
        + tags             = {
            + "Name" = "lesson-5-vpc-private-rt-1"
            }
        + tags_all         = {
            + "Name" = "lesson-5-vpc-private-rt-1"
            }
        + vpc_id           = (known after apply)
        }

    # module.vpc.aws_route_table.private[1] will be created
    + resource "aws_route_table" "private" {
        + arn              = (known after apply)
        + id               = (known after apply)
        + owner_id         = (known after apply)
        + propagating_vgws = (known after apply)
        + region           = "eu-central-1"
        + route            = [
            + {
                + cidr_block                 = "0.0.0.0/0"
                + nat_gateway_id             = (known after apply)
                    # (11 unchanged attributes hidden)
                },
            ]
        + tags             = {
            + "Name" = "lesson-5-vpc-private-rt-2"
            }
        + tags_all         = {
            + "Name" = "lesson-5-vpc-private-rt-2"
            }
        + vpc_id           = (known after apply)
        }

    # module.vpc.aws_route_table.private[2] will be created
    + resource "aws_route_table" "private" {
        + arn              = (known after apply)
        + id               = (known after apply)
        + owner_id         = (known after apply)
        + propagating_vgws = (known after apply)
        + region           = "eu-central-1"
        + route            = [
            + {
                + cidr_block                 = "0.0.0.0/0"
                + nat_gateway_id             = (known after apply)
                    # (11 unchanged attributes hidden)
                },
            ]
        + tags             = {
            + "Name" = "lesson-5-vpc-private-rt-3"
            }
        + tags_all         = {
            + "Name" = "lesson-5-vpc-private-rt-3"
            }
        + vpc_id           = (known after apply)
        }

    # module.vpc.aws_route_table.public will be created
    + resource "aws_route_table" "public" {
        + arn              = (known after apply)
        + id               = (known after apply)
        + owner_id         = (known after apply)
        + propagating_vgws = (known after apply)
        + region           = "eu-central-1"
        + route            = [
            + {
                + cidr_block                 = "0.0.0.0/0"
                + gateway_id                 = (known after apply)
                    # (11 unchanged attributes hidden)
                },
            ]
        + tags             = {
            + "Name" = "lesson-5-vpc-public-rt"
            }
        + tags_all         = {
            + "Name" = "lesson-5-vpc-public-rt"
            }
        + vpc_id           = (known after apply)
        }

    # module.vpc.aws_route_table_association.private[0] will be created
    + resource "aws_route_table_association" "private" {
        + id             = (known after apply)
        + region         = "eu-central-1"
        + route_table_id = (known after apply)
        + subnet_id      = (known after apply)
        }

    # module.vpc.aws_route_table_association.private[1] will be created
    + resource "aws_route_table_association" "private" {
        + id             = (known after apply)
        + region         = "eu-central-1"
        + route_table_id = (known after apply)
        + subnet_id      = (known after apply)
        }

    # module.vpc.aws_route_table_association.private[2] will be created
    + resource "aws_route_table_association" "private" {
        + id             = (known after apply)
        + region         = "eu-central-1"
        + route_table_id = (known after apply)
        + subnet_id      = (known after apply)
        }

    # module.vpc.aws_route_table_association.public[0] will be created
    + resource "aws_route_table_association" "public" {
        + id             = (known after apply)
        + region         = "eu-central-1"
        + route_table_id = (known after apply)
        + subnet_id      = (known after apply)
        }

    # module.vpc.aws_route_table_association.public[1] will be created
    + resource "aws_route_table_association" "public" {
        + id             = (known after apply)
        + region         = "eu-central-1"
        + route_table_id = (known after apply)
        + subnet_id      = (known after apply)
        }

    # module.vpc.aws_route_table_association.public[2] will be created
    + resource "aws_route_table_association" "public" {
        + id             = (known after apply)
        + region         = "eu-central-1"
        + route_table_id = (known after apply)
        + subnet_id      = (known after apply)
        }

    # module.vpc.aws_subnet.private[0] will be created
    + resource "aws_subnet" "private" {
        + arn                                            = (known after apply)
        + assign_ipv6_address_on_creation                = false
        + availability_zone                              = "eu-central-1a"
        + availability_zone_id                           = (known after apply)
        + cidr_block                                     = "10.0.4.0/24"
        + enable_dns64                                   = false
        + enable_resource_name_dns_a_record_on_launch    = false
        + enable_resource_name_dns_aaaa_record_on_launch = false
        + id                                             = (known after apply)
        + ipv6_cidr_block_association_id                 = (known after apply)
        + ipv6_native                                    = false
        + map_public_ip_on_launch                        = false
        + owner_id                                       = (known after apply)
        + private_dns_hostname_type_on_launch            = (known after apply)
        + region                                         = "eu-central-1"
        + tags                                           = {
            + "Name" = "lesson-5-vpc-private-subnet-1"
            }
        + tags_all                                       = {
            + "Name" = "lesson-5-vpc-private-subnet-1"
            }
        + vpc_id                                         = (known after apply)
        }

    # module.vpc.aws_subnet.private[1] will be created
    + resource "aws_subnet" "private" {
        + arn                                            = (known after apply)
        + assign_ipv6_address_on_creation                = false
        + availability_zone                              = "eu-central-1b"
        + availability_zone_id                           = (known after apply)
        + cidr_block                                     = "10.0.5.0/24"
        + enable_dns64                                   = false
        + enable_resource_name_dns_a_record_on_launch    = false
        + enable_resource_name_dns_aaaa_record_on_launch = false
        + id                                             = (known after apply)
        + ipv6_cidr_block_association_id                 = (known after apply)
        + ipv6_native                                    = false
        + map_public_ip_on_launch                        = false
        + owner_id                                       = (known after apply)
        + private_dns_hostname_type_on_launch            = (known after apply)
        + region                                         = "eu-central-1"
        + tags                                           = {
            + "Name" = "lesson-5-vpc-private-subnet-2"
            }
        + tags_all                                       = {
            + "Name" = "lesson-5-vpc-private-subnet-2"
            }
        + vpc_id                                         = (known after apply)
        }

    # module.vpc.aws_subnet.private[2] will be created
    + resource "aws_subnet" "private" {
        + arn                                            = (known after apply)
        + assign_ipv6_address_on_creation                = false
        + availability_zone                              = "eu-central-1c"
        + availability_zone_id                           = (known after apply)
        + cidr_block                                     = "10.0.6.0/24"
        + enable_dns64                                   = false
        + enable_resource_name_dns_a_record_on_launch    = false
        + enable_resource_name_dns_aaaa_record_on_launch = false
        + id                                             = (known after apply)
        + ipv6_cidr_block_association_id                 = (known after apply)
        + ipv6_native                                    = false
        + map_public_ip_on_launch                        = false
        + owner_id                                       = (known after apply)
        + private_dns_hostname_type_on_launch            = (known after apply)
        + region                                         = "eu-central-1"
        + tags                                           = {
            + "Name" = "lesson-5-vpc-private-subnet-3"
            }
        + tags_all                                       = {
            + "Name" = "lesson-5-vpc-private-subnet-3"
            }
        + vpc_id                                         = (known after apply)
        }

    # module.vpc.aws_subnet.public[0] will be created
    + resource "aws_subnet" "public" {
        + arn                                            = (known after apply)
        + assign_ipv6_address_on_creation                = false
        + availability_zone                              = "eu-central-1a"
        + availability_zone_id                           = (known after apply)
        + cidr_block                                     = "10.0.1.0/24"
        + enable_dns64                                   = false
        + enable_resource_name_dns_a_record_on_launch    = false
        + enable_resource_name_dns_aaaa_record_on_launch = false
        + id                                             = (known after apply)
        + ipv6_cidr_block_association_id                 = (known after apply)
        + ipv6_native                                    = false
        + map_public_ip_on_launch                        = true
        + owner_id                                       = (known after apply)
        + private_dns_hostname_type_on_launch            = (known after apply)
        + region                                         = "eu-central-1"
        + tags                                           = {
            + "Name" = "lesson-5-vpc-public-subnet-1"
            }
        + tags_all                                       = {
            + "Name" = "lesson-5-vpc-public-subnet-1"
            }
        + vpc_id                                         = (known after apply)
        }

    # module.vpc.aws_subnet.public[1] will be created
    + resource "aws_subnet" "public" {
        + arn                                            = (known after apply)
        + assign_ipv6_address_on_creation                = false
        + availability_zone                              = "eu-central-1b"
        + availability_zone_id                           = (known after apply)
        + cidr_block                                     = "10.0.2.0/24"
        + enable_dns64                                   = false
        + enable_resource_name_dns_a_record_on_launch    = false
        + enable_resource_name_dns_aaaa_record_on_launch = false
        + id                                             = (known after apply)
        + ipv6_cidr_block_association_id                 = (known after apply)
        + ipv6_native                                    = false
        + map_public_ip_on_launch                        = true
        + owner_id                                       = (known after apply)
        + private_dns_hostname_type_on_launch            = (known after apply)
        + region                                         = "eu-central-1"
        + tags                                           = {
            + "Name" = "lesson-5-vpc-public-subnet-2"
            }
        + tags_all                                       = {
            + "Name" = "lesson-5-vpc-public-subnet-2"
            }
        + vpc_id                                         = (known after apply)
        }

    # module.vpc.aws_subnet.public[2] will be created
    + resource "aws_subnet" "public" {
        + arn                                            = (known after apply)
        + assign_ipv6_address_on_creation                = false
        + availability_zone                              = "eu-central-1c"
        + availability_zone_id                           = (known after apply)
        + cidr_block                                     = "10.0.3.0/24"
        + enable_dns64                                   = false
        + enable_resource_name_dns_a_record_on_launch    = false
        + enable_resource_name_dns_aaaa_record_on_launch = false
        + id                                             = (known after apply)
        + ipv6_cidr_block_association_id                 = (known after apply)
        + ipv6_native                                    = false
        + map_public_ip_on_launch                        = true
        + owner_id                                       = (known after apply)
        + private_dns_hostname_type_on_launch            = (known after apply)
        + region                                         = "eu-central-1"
        + tags                                           = {
            + "Name" = "lesson-5-vpc-public-subnet-3"
            }
        + tags_all                                       = {
            + "Name" = "lesson-5-vpc-public-subnet-3"
            }
        + vpc_id                                         = (known after apply)
        }

    # module.vpc.aws_vpc.main will be created
    + resource "aws_vpc" "main" {
        + arn                                  = (known after apply)
        + cidr_block                           = "10.0.0.0/16"
        + default_network_acl_id               = (known after apply)
        + default_route_table_id               = (known after apply)
        + default_security_group_id            = (known after apply)
        + dhcp_options_id                      = (known after apply)
        + enable_dns_hostnames                 = true
        + enable_dns_support                   = true
        + enable_network_address_usage_metrics = (known after apply)
        + id                                   = (known after apply)
        + instance_tenancy                     = "default"
        + ipv6_association_id                  = (known after apply)
        + ipv6_cidr_block                      = (known after apply)
        + ipv6_cidr_block_network_border_group = (known after apply)
        + main_route_table_id                  = (known after apply)
        + owner_id                             = (known after apply)
        + region                               = "eu-central-1"
        + tags                                 = {
            + "Name" = "lesson-5-vpc"
            }
        + tags_all                             = {
            + "Name" = "lesson-5-vpc"
            }
        }

    Plan: 31 to add, 0 to change, 0 to destroy.

    Changes to Outputs:
    + dynamodb_table_name = "terraform-locks"
    + ecr_repository_url  = (known after apply)
    + private_subnet_ids  = [
        + (known after apply),
        + (known after apply),
        + (known after apply),
        ]
    + public_subnet_ids   = [
        + (known after apply),
        + (known after apply),
        + (known after apply),
        ]
    + s3_bucket_url       = "s3://tf-state-aleksey-goit-2025-07-08"
    + vpc_id              = (known after apply)

    Do you want to perform these actions?
    Terraform will perform the actions described above.
    Only 'yes' will be accepted to approve.

    Enter a value:
    ```
    Введіть `yes`, і натисніть Enter.
    ```bash
    Enter a value: yes
    ```
    Результат в терминале:
    ```bash

    ```
[Top :arrow_double_up:](#top)

<a id="4"></a>

<a href="#8"><img src="https://img.shields.io/badge/5-A9225C?style=for-the-badge"/></a> **Знищення інфраструктури (Необов'язково):**
    Якщо вам потрібно видалити всі ресурси, створені цією конфігурацією Terraform, скористайтеся наступною командою. Будьте обережні, оскільки це призведе до видалення всіх створених ресурсів.
    ```bash
    terraform destroy
    ```
    Введіть `yes`, коли буде запропоновано підтвердити знищення.

[Top :arrow_double_up:](#top)