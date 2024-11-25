
# Get the existing VPC by name (change to your VPC ID or name)
data "aws_vpc" "existing_vpc" {
  id = var.vpc_id  # Replace with your VPC ID
}

# Get the existing subnets for the EKS cluster (you can use public or private subnets)
data "aws_subnets" "eks_subnets" {
  filter {
    name = "availabilityZone"
    values = ["us-east-1a", "us-east-1b"]
    //values = [data.aws_vpc.existing_vpc.id]
  }
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
    subnet_ids = [
      data.aws_subnets.eks_subnets.ids[0],  # Example: first subnet in supported AZ
      data.aws_subnets.eks_subnets.ids[1]   # Example: second subnet in supported AZ
    ]
    //subnet_ids = data.aws_subnets.eks_subnets.ids
    security_group_ids = [aws_security_group.eks_sg.id]
  }

  depends_on = [aws_iam_role_policy_attachment.eks_policy_attachment]
}

# IAM Role for EKS Worker Node Group
resource "aws_iam_role" "eks_node_role" {
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "eks-node-role"
  }
}

# Attach the necessary policies to the EKS node role
resource "aws_iam_role_policy_attachment" "eks_node_policy_attachment" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy_attachment" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "eks_vpc_cni_policy_attachment" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
}

# EKS Node Group Configuration
resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "my-node-group"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = data.aws_subnets.eks_subnets.ids
  instance_types  = ["t3.small"]  # Modify based on your requirements
  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  depends_on = [aws_eks_cluster.eks_cluster]
}
