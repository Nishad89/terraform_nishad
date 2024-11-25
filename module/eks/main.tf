
# Get the existing VPC by name (change to your VPC ID or name)
data "aws_vpc" "existing_vpc" {
  id = var.vpc_id  # Replace with your VPC ID
}

# Get the existing subnets for the EKS cluster (you can use public or private subnets)
data "aws_subnet_ids" "eks_subnets" {
  vpc_id = data.aws_vpc.existing_vpc.id
}

# Create an IAM role for the EKS Cluster
resource "aws_iam_role" "eks_role" {
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "eks-cluster-role"
  }
}

# Attach the necessary policies to the EKS role
resource "aws_iam_role_policy_attachment" "eks_policy_attachment" {
  role       = aws_iam_role.eks_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# Security group for EKS
resource "aws_security_group" "eks_sg" {
  vpc_id = data.aws_vpc.existing_vpc.id
  name   = "eks-cluster-sg"
}

# Create the EKS Cluster
resource "aws_eks_cluster" "eks_cluster" {
  name     = "my-eks-cluster"
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids = data.aws_subnet_ids.eks_subnets.ids
    security_group_ids = [aws_security_group.eks_sg.id]
  }

  depends_on = [aws_iam_role_policy_attachment.eks_policy_attachment]
}
