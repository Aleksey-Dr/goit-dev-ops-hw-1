# Progect/modules/vpc/vpc.tf
# Створення VPC, підмереж та Internet Gateway

# Створення VPC
resource "aws_vpc" "main" {
  # CIDR блок для VPC
  cidr_block = var.vpc_cidr_block
  # Увімкнення DNS підтримки
  enable_dns_support = true
  # Увімкнення DNS хостнеймів
  enable_dns_hostnames = true

  # Теги для VPC
  tags = merge(var.tags, {
    Name = var.vpc_name
  })
}

# Створення Internet Gateway для публічного доступу
resource "aws_internet_gateway" "main" {
  # Прив'язка до створеної VPC
  vpc_id = aws_vpc.main.id

  # Теги для Internet Gateway
  tags = merge(var.tags, {
    Name = "${var.vpc_name}-igw"
  })
}

# Отримання доступних зон доступності в регіоні
data "aws_availability_zones" "available" {
  state = "available"
}

# Створення публічних підмереж
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs) # Кількість підмереж за кількістю CIDR блоків

  # Прив'язка до VPC
  vpc_id = aws_vpc.main.id
  # CIDR блок для поточної підмережі
  cidr_block = var.public_subnet_cidrs[count.index]
  # Прив'язка до зони доступності
  availability_zone = data.aws_availability_zones.available.names[count.index]
  # Автоматичне призначення публічних IP адрес
  map_public_ip_on_launch = true

  # Теги для публічних підмереж
  tags = merge(var.tags, {
    Name = "${var.vpc_name}-public-subnet-${count.index + 1}"
  })
}

# Створення приватних підмереж
resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs) # Кількість підмереж за кількістю CIDR блоків

  # Прив'язка до VPC
  vpc_id = aws_vpc.main.id
  # CIDR блок для поточної підмережі
  cidr_block = var.private_subnet_cidrs[count.index]
  # Прив'язка до зони доступності
  availability_zone = data.aws_availability_zones.available.names[count.index]
  # Заборона автоматичного призначення публічних IP адрес
  map_public_ip_on_launch = false

  # Теги для приватних підмереж
  tags = merge(var.tags, {
    Name = "${var.vpc_name}-private-subnet-${count.index + 1}"
  })
}

# Створення NAT Gateway для приватних підмереж (для вихідного доступу до інтернету)
resource "aws_nat_gateway" "main" {
  count = length(aws_subnet.public) # Створюємо NAT Gateway для кожної публічної підмережі

  # Прив'язка до публічної підмережі
  subnet_id = aws_subnet.public[count.index].id
  # Прив'язка до Elastic IP (EIP)
  allocation_id = aws_eip.nat[count.index].id

  # Залежність від Internet Gateway
  depends_on = [aws_internet_gateway.main]

  # Теги для NAT Gateway
  tags = merge(var.tags, {
    Name = "${var.vpc_name}-nat-gateway-${count.index + 1}"
  })
}

# Створення Elastic IP (EIP) для NAT Gateway
resource "aws_eip" "nat" {
  count = length(aws_subnet.public) # Створюємо EIP для кожного NAT Gateway

  # Прив'язка до VPC
  vpc = true

  # Теги для EIP
  tags = merge(var.tags, {
    Name = "${var.vpc_name}-eip-${count.index + 1}"
  })
}
