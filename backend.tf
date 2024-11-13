terraform {
  backend "s3" {
    bucket         = "my-backet123"
    key            = "terraform/${terraform.workspace}/test.tfstate"
    region         = "us-east-1"
  }
}
