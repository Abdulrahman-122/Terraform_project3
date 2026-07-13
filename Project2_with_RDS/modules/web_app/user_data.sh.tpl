#!/bin/bash
exec >/var/log/user_data.log 2>&1

set -euxo pipefail

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

git clone https://github.com/Abdulrahman-122/Terraform_project3.git
cd Terraform_project3/gym_using_flask 

cat >.env.production <<'EOF'
DATABASE_URL=${database_url}
FLASK_APP=run.py
SECRET_KEY='9a8d782e874f3e779dfa49e6dacb27ec5a4d4992d732506b9911ead37820c357'
SESSION_COOKIE_SAMESITE=Lax
EOF

docker compose up -d --build
docker compose ps

