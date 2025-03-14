# Configure the AWS Provider
provider "aws" {
  profile                  = var.profile
  shared_credentials_files = ["C:\\Users\\danii\\.aws\\credentials"]
  region                   = var.region
}


provider "kubernetes" {
  host                   = aws_eks_cluster.control_plane.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.control_plane.certificate_authority[0].data)
  exec {
    api_version = "client.authentication.k8s.io/v1"
    args        = ["eks", "--profile", var.profile, "--region", var.region, "get-token", "--cluster-name", aws_eks_cluster.control_plane.id]
    command     = "aws"
  }
}

provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.control_plane.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.control_plane.certificate_authority[0].data)
    exec {
      api_version = "client.authentication.k8s.io/v1"
      args        = ["eks", "--profile", var.profile, "--region", var.region, "get-token", "--cluster-name", aws_eks_cluster.control_plane.id]
      command     = "aws"
    }
  }
}
