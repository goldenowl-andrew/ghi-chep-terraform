output "cluster_id" {
  description = "EKS cluster ID."
  value       = module.eks.cluster_id
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane."
  value       = module.eks.cluster_endpoint
}

output "cluster_certificate_authority" {
  description = "value of the cluster's certificate authority."
  value       = module.eks.cluster_certificate_authority
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = local.cluster_name
}

output "vpc_id" {
  description = "VPC Id of EKS."
  value       = module.vpc.vpc_id
}
output "security_group_id" {
  description = "Security Group Id of EKS."
  value       = module.sg.security_group_id
}

output "cluster_oidc_issuer_url" {
  value = module.eks.cluster_oidc_issuer_url
}

output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}