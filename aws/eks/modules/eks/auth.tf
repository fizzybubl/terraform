resource "aws_eks_access_entry" "name" {
  cluster_name = aws_eks_cluster.this.name
  principal_arn = ""
}