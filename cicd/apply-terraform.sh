#!/bin/bash

# fail on any error
set -eu

# go back to the previous directory
cd .. 

# initialize terraform
terraform init
terraform workspace new dev
terraform workspace select dev
# # apply terraform
terraform apply -var-file="dev.tfvars" -auto-approve

# destroy terraform
# terraform destroy -auto-approve