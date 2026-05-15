    output "cluster_name" {
  value       = module.eks.cluster_id
  description = "The EKS cluster name"
}