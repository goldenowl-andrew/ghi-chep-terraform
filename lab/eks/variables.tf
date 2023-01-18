locals {
  cluster_name    = "eks_cluster"
  vpc_name        = "eks_cluster"
  eks_userarn     = "arn:aws:iam::949715427887:user/dungla_eks"
  eks_username    = "dungla_eks"
  common_tags = {
    terraform = var.terraform
  }
}
variable "region" {
  type = string
  default = "us-west-2"
}
variable "environment" {
    default = "dev"
}

variable instance_type_nodes {
    default = "m5.large"
}

variable desired_nodes {
    type = number
    default = 3
}

#tags
variable "terraform" {
  default = "True"
}

variable public_access_cidrs {
  type        = list(string)
 description = "Public Subnet CIDR values for eks access"
 default     = ["172.40.0.0/16", "202.134.19.195/32"]
}

