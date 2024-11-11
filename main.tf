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
              sudo apt update
              sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
              https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
              echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
              https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
              /etc/apt/sources.list.d/jenkins.list > /dev/null
              sudo apt-get update
              sudo apt-get install fontconfig openjdk-17-jre
              sudo apt-get install jenkins
              sudo systemctl start jenkins
              sudo systemctl enable jenkins
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
