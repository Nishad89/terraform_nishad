# Providers
provider "aws" {
  region = "us-east-1"  # specify your region
}

# Security Group for Jenkins
resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-sg"
  description = "Allow SSH and HTTP access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance for Jenkins
resource "aws_instance" "jenkins_server" {
  ami           = "ami-0866a3c8686eaeeba"
  instance_type = "t3.medium"
  security_groups = [aws_security_group.jenkins_sg.name]

  # Script to install Jenkins
  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install -y curl unzip
              curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
              unzip awscliv2.zip
              sudo ./aws/install
              sudo apt update -y
              sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
              echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
              https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
              /etc/apt/sources.list.d/jenkins.list > /dev/null
              sudo apt-get update -y
              sudo apt-get install -y fontconfig openjdk-17-jre
              sudo apt-get install -y jenkins
              sudo systemctl start jenkins
              sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
              wget -O- https://apt.releases.hashicorp.com/gpg | \
              gpg --dearmor | \
              sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
              gpg --no-default-keyring \
              --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
              --fingerprint

              echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
              https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
              sudo tee /etc/apt/sources.list.d/hashicorp.list

              sudo apt update -y
              sudo apt-get install -y terraform
              EOF
  tags = {
    Name = "Jenkins-Server"
  }
}

# Output the public IP of the Jenkins instance
output "jenkins_public_ip" {
  description = "The public IP address of the Jenkins server"
  value       = aws_instance.jenkins_server.public_ip
}
