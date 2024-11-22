terraform {
  backend "s3" {
    bucket         = "my-backet123"      # Replace with your S3 bucket name
    key            = "terraform/terraform.tfstate"      # Path inside the bucket for the state file
    region         = "us-east-1"                      # AWS region         # DynamoDB table for state locking

  }
}
