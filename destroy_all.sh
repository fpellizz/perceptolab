#!/bin/bash

cd ./observability
terraform apply -auto-approve -destroy
cd ../app
terraform apply -auto-approve -destroy
cd ../postgres
terraform apply -auto-approve -destroy
echo "All done."