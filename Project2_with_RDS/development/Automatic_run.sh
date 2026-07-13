#!/bin/bash
echo "=============================="
echo "Deploying infrastructure..."
echo "=============================="
set -euf pipefail

echo "Applying infrastructure ...."
echo  "please before we go (check your bootstrap(initialization  in  order to build our backend on top of it))"
echo 
terraform  apply --auto-approve



