#!/bin/bash

echo "===== AKTUALIZACE SYSTÉMU A ZÁKLADNÍCH BALÍČKŮ ====="
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y gnupg curl ca-certificates apt-transport-https software-properties-common lsb-release
sudo apt install iotop

echo "===== INSTALACE DOCKERU ====="
if ! command -v docker &> /dev/null; then
    echo "Stahuji a instaluji Docker (oficiální cesta)..."
    curl -fsSL https://get.docker.com | sh
else
    echo "Docker je již nainstalován."
fi

echo "Zapínám a spouštím službu Docker..."
sudo systemctl enable docker
sudo systemctl start docker

echo "Přidávám uživatele do skupiny docker (pro správu bez sudo)..."
sudo usermod -aG docker "$USER"

echo "===== INSTALUJI DOCKER COMPOSE V2 (CLI plugin) ====="
sudo mkdir -p /usr/local/lib/docker/cli-plugins
sudo curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 -o /usr/local/lib/docker/cli-plugins/docker-compose
sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

echo "Ověření instalace Docker Compose pluginu:"
docker compose version

echo "===== PŘIDÁVÁM REPOZITÁŘ PI NETWORK ====="
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://apt.minepi.com/repository.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/pinetwork-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/pinetwork-archive-keyring.gpg] https://apt.minepi.com stable main" | sudo tee /etc/apt/sources.list.d/pinetwork.list > /dev/null
sudo apt-get update

echo "===== INSTALUJI PI NODE ====="
sudo apt-get install -y pi-node

echo
echo "--------------------------------------------"
echo "Instalace je hotová! Pokud script přidal uživatele do skupiny docker, odhlašte se a znovu přihlašte."
echo "Pokračujte příkazem: pi-node initialize"
echo "--------------------------------------------"
