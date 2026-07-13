#!/bin/bash
exec >/var/log/user_data.log 2>&1

set -eux pipefail

apt-get  update -y
apt-get install -y \
    docker.io   \
    docker-compose-v2 \
    git

sleep 10 

systemctl enable docker
systemctl start docker
usermod -aG docker ubuntu
cd /opt

git clone https://github.com/Abdulrahman-122/Terrafrom2_project.git   
cd Terrafrom2_project/gym_using_flask 

docker compose up -d --build
docker compose ps

