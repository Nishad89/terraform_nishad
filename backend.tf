terraform {
  backend "s3" {
    bucket  = "my-backet123"
    key     = "terraform/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}