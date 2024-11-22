provider "aws" {
  region = "us-east-1"
}
terraform {
  backend "s3" {
    bucket  = "my-backet123"
    key     = "terraform/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
# module "ec2_instance" {
#   source = "./module/ec2"
#   ami = var.ami
#   instance_type = var.instance_type
# }
module "aws_s3_bucket" {
  source         = "./module/s3"
  s3_bucket_name = var.s3_bucket_name
}