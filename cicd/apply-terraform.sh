#!/bin/bash

# fail on any error
set -eu

# go back to the previous directory
cd .. 

# initialize terraform
terraform init
# terraform workspace select dev
# terraform apply -var-file="dev.tfvars" -auto-approve
# terraform workspace select qa
# terraform apply -var-file="qa.tfvars" -auto-approve
terraform workspace select dev
terraform destroy -var-file="dev.tfvars" -auto-approve
terraform workspace select qa
terraform destroy -var-file="qa.tfvars"
# destroy terraform
# terraform destroy -auto-approve