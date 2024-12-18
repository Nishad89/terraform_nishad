
variable "securitygroups" {
  description = "The name of the sg"
  type        = list(string)
}


variable "ami" {
  description = "The AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "The type of EC2 instance"
  type        = string
}

