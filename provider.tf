provider "aws" {
  region = "us-east-1"
}
terraform {
  backend "s3" {
    bucket         = "my-backet123"
    key            = "terraform/dev/test.tfstate"
    region         = "us-east-1"
  }
}
