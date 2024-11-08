variable "ami" {
  description = "The AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "The type of EC2 instance"
  type        = string
}
variable "s3_bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}
variable "sg_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "security_groups" {
  description = "The name of the S3 bucket"
  type        = string
}