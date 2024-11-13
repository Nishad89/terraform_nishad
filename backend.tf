terraform {
  backend "s3" {
    bucket         = "my-backet123"           # Replace with your S3 bucket name
    key            = "terraform/terraform.tfstate"           # Key is the same; workspaces will be used
    region         = "us-east-1"
  }
}
