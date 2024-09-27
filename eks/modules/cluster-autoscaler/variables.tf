variable "openid_connect_provider" {
  type = object({
    arn = string
  })
  description = "aws open id connect provider used to create cluster scaler"
}


variable "control_plane" {
  type = object({
    issuer = string,
    id = string
  })
  description = "eks control plane"
}

variable "namespace" {
  type    = string
  default = "kube-system"
}


variable "mixin_instances" {
  type = set(string)
  # default = [
  #   "r5.2xlarge",
  #   "r5d.2xlarge",
  #   "r5a.2xlarge",
  #   "r5ad.2xlarge",
  #   "r5n.2xlarge",
  #   "r5dn.2xlarge",
  #   "r4.2xlarge",
  #   "i3.2xlarge",
  # ]

  default = []
}