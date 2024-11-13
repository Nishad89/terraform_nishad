terraform {
  backend "s3" {
    bucket         = "my-backet123"
    key            = "terraform/${terraform.workspace}/terraform.tfstate"
    region         = "us-east-1"
  }
}
