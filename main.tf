

module "aws_security_group" {
  source = "./module/sg"
  sg_name = var.sg_name
}

module "ec2_instance" {
  source        = "./module/ec2"
  ami           = var.ami
  instance_type = var.instance_type
}

module "aws_s3_bucket" {
  source         = "./module/s3"
  s3_bucket_name = var.s3_bucket_name
}
