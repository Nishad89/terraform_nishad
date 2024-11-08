

module "aws_security_group" {
  source = "./module/sg"
  sg_name = var.sg_name
  vpc_id = var.vpc_id
}

module "ec2_instance" {
  source        = "./module/ec2"
  ami           = var.ami
  instance_type = var.instance_type
  securitygroups = var.security_groups
  
}

module "aws_s3_bucket" {
  source         = "./module/s3"
  s3_bucket_name = var.s3_bucket_name
}
