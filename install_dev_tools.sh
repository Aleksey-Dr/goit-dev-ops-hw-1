#!/bin/bash

# Функція для перевірки наявності команди
command_exists () {
  command -v "$1" >/dev/null 2>&1
}

echo "Початок встановлення інструментів розробки..."

# Встановлення Docker
echo "Перевірка та встановлення Docker..."
if command_exists docker; then
  echo "Docker вже встановлено."
else
  echo "Встановлення Docker..."
  sudo apt-get update
  sudo apt-get install -y ca-certificates curl gnupg
  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  sudo chmod a+r /etc/apt/keyrings/docker.gpg
  echo \
    "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  sudo usermod -aG docker "$USER"
  echo "Docker встановлено. Будь ласка, вийдіть з системи та увійдіть знову, щоб застосувати зміни групи Docker."
fi

# Встановлення Docker Compose (якщо він ще не встановлений як плагін)
echo "Перевірка та встановлення Docker Compose..."
if command_exists docker-compose || docker compose version >/dev/null 2>&1; then
  echo "Docker Compose вже встановлено."
else
  echo "Встановлення Docker Compose..."
  # Docker Compose V2 встановлюється як docker compose plugin
  if command_exists docker; then
    echo "Docker Compose V2 буде встановлено як частина Docker."
    # Це вже має бути встановлено з docker-compose-plugin вище, але додаємо як запасний варіант
    sudo apt-get install -y docker-compose-plugin
  else
    # Якщо Docker не встановлено, встановлюємо окремо Docker Compose V1 (застарілий, але для сумісності)
    echo "Docker не знайдено, встановлення Docker Compose V1 (застарілий)."
    DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
    sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
  fi
  echo "Docker Compose встановлено."
fi


# Встановлення Python 3.9+
echo "Перевірка та встановлення Python 3.9 або новішої версії..."
PYTHON_VERSION=$(python3 -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')" 2>/dev/null)
if [[ $(echo "$PYTHON_VERSION >= 3.9" | bc -l) -eq 1 ]]; then
  echo "Python $PYTHON_VERSION (3.9 або новіша) вже встановлено."
else
  echo "Встановлення Python 3.9 або новішої версії..."
  sudo apt-get update
  sudo apt-get install -y software-properties-common
  sudo add-apt-repository -y ppa:deadsnakes/ppa
  sudo apt-get update
  sudo apt-get install -y python3.9 python3.9-venv python3.9-distutils # або python3.10, python3.11 тощо, залежно від PPA
  sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.9 1
  echo "Python 3.9 або новіша версія встановлено."
fi

# Встановлення Django
echo "Перевірка та встановлення Django..."
if python3 -c "import django" &> /dev/null; then
  echo "Django вже встановлено."
else
  echo "Встановлення Django..."
  pip3 install Django
  echo "Django встановлено."
fi

echo "Встановлення інструментів розробки завершено."