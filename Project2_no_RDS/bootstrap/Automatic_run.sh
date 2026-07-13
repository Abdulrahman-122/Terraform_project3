#!/bin/bash

set -e

echo "=============================="
echo "Bootstraping infrastructure..."
echo "=============================="

terraform apply -auto-approve

# echo
# echo "Destroying infrastructure..."

# terraform destroy -auto-approve
