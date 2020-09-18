resource "aws_iam_role" "tf-eks-cluster" {
  name = "tf-eks-cluster-${terraform.workspace}"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "tf-eks-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = "${aws_iam_role.tf-eks-cluster.name}"
}

resource "aws_iam_role_policy_attachment" "tf-eks-cluster-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = "${aws_iam_role.tf-eks-cluster.name}"
}


resource "aws_eks_cluster" "tf_cluster" {
  name     = var.eks_cluster_name[terraform.workspace]
  role_arn = "${aws_iam_role.tf-eks-cluster.arn}"
  vpc_config {
    subnet_ids = ["${aws_subnet.public[0].id}", "${aws_subnet.public[1].id}", "${aws_subnet.public[2].id}"]
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    "aws_iam_role_policy_attachment.tf-eks-cluster-AmazonEKSClusterPolicy",
    "aws_iam_role_policy_attachment.tf-eks-cluster-AmazonEKSServicePolicy",
  ]
}

output "endpoint" {
  value = "${aws_eks_cluster.tf_cluster.endpoint}"
}

output "kubeconfig-certificate-authority-data" {
  value = "${aws_eks_cluster.tf_cluster.certificate_authority.0.data}"
}


