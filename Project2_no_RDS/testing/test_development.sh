#!/bin/bash
set -e 

cd development/
echo "initialization  infrastructure"
terraform init
echo "Deploying infrastrucutre"
terraform apply  --auto-approve

sleep 60

echo
for ip in $(terraform  output -json public_ip|jq -r  '.[]');do
    echo "Checking http://$ip"
    if curl -f --silent http://$ip > /dev/null; then
        echo "Health Check Passed!"
    else
        echo "Health Check Failed!"
    fi
done
echo
echo "Destroying infrastructure..."

terraform destroy -auto-approve