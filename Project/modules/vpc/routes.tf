# Progect/modules/vpc/routes.tf
# Налаштування таблиць маршрутизації для публічних та приватних підмереж

# Створення таблиці маршрутизації для публічних підмереж
resource "aws_route_table" "public" {
  # Прив'язка до VPC
  vpc_id = aws_vpc.main.id

  # Маршрут за замовчуванням до Internet Gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  # Теги для таблиці маршрутизації
  tags = merge(var.tags, {
    Name = "${var.vpc_name}-public-route-table"
  })
}

# Асоціація публічних підмереж з публічною таблицею маршрутизації
resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Створення таблиці маршрутизації для приватних підмереж
resource "aws_route_table" "private" {
  count = length(aws_subnet.private) # Створюємо окрему таблицю маршрутизації для кожної приватної підмережі

  # Прив'язка до VPC
  vpc_id = aws_vpc.main.id

  # Маршрут за замовчуванням до відповідного NAT Gateway
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[count.index].id
  }

  # Теги для таблиці маршрутизації
  tags = merge(var.tags, {
    Name = "${var.vpc_name}-private-route-table-${count.index + 1}"
  })
}

# Асоціація приватних підмереж з приватними таблицями маршрутизації
resource "aws_route_table_association" "private" {
  count = length(aws_subnet.private)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}
