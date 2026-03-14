# IAM Role pour EKS Control Plane
resource "aws_iam_role" "eks_cluster" {
  name = "eks-cluster-role-${var.env}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}

# IAM Role pour les Nodes
resource "aws_iam_role" "eks_nodes" {
  name = "eks-nodes-role-${var.env}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_worker_node" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_nodes.name
}

resource "aws_iam_role_policy_attachment" "eks_cni" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_nodes.name
}

resource "aws_iam_role_policy_attachment" "eks_ecr" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_nodes.name
}

#trivy:ignore:AVD-AWS-0041
#trivy:ignore:AVD-AWS-0040
#trivy:ignore:AVD-AWS-0039
#trivy:ignore:AVD-AWS-0038
#trivy:ignore:AVD-AWS-0037
resource "aws_eks_cluster" "this" {
  name     = "eks-${var.env}"
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    subnet_ids = [
      var.public_subnet_id,
      var.private_subnet_id,
      var.private_subnet_b_id
    ]
  }

  depends_on = [aws_iam_role_policy_attachment.eks_cluster_policy]
}

#trivy:ignore:AVD-AWS-0035
#trivy:ignore:AVD-AWS-0036
resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "ng-${var.env}"
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids      = [var.private_subnet_id, var.private_subnet_b_id]
  instance_types  = ["t3.medium"]

  scaling_config {
    desired_size = 2
    min_size     = 1
    max_size     = 3
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node,
    aws_iam_role_policy_attachment.eks_cni,
    aws_iam_role_policy_attachment.eks_ecr,
  ]
}