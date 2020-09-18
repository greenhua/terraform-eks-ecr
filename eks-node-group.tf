resource "aws_iam_role" "eks-node-group" {
  name = "eks-node-group-1-${terraform.workspace}"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "eks-node-group-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks-node-group.name
}

resource "aws_iam_role_policy_attachment" "eks-node-group-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks-node-group.name
}

resource "aws_iam_role_policy_attachment" "eks-node-group-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks-node-group.name
}



resource "aws_eks_node_group" "tf_cluster-group-1" {
  cluster_name    = aws_eks_cluster.tf_cluster.name
  instance_types = var.instance_types[terraform.workspace]
  node_group_name = var.node_group_name[terraform.workspace]
  node_role_arn   = aws_iam_role.eks-node-group.arn
  subnet_ids      = ["${aws_subnet.public[0].id}", "${aws_subnet.public[1].id}", "${aws_subnet.public[2].id}"]

  remote_access  {
    ec2_ssh_key     = "vladi-tz"
  }

  scaling_config {
    desired_size = 1
    max_size     = 5
    min_size     = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.eks-node-group-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks-node-group-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks-node-group-AmazonEC2ContainerRegistryReadOnly,
  ]
}
