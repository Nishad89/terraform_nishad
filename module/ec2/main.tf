resource "aws_instance" "this" {
  ami           = var.ami
  instance_type = var.instance_type
  security_groups = var.securitygroups

  tags = {
    Name        = "terraform-test-${terraform.workspace}"
}
}