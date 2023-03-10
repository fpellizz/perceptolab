#!/bin/bash

cd ./postgres
terraform init
terraform validate
terraform plan    
terraform apply -auto-approve

cd ../app
terraform init
terraform validate
terraform plan
terraform apply -auto-approve

cd ../observability
terraform init
terraform validate
terraform plan
terraform apply -auto-approve

echo "Deploy terminato"