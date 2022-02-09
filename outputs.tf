output "namespace" {
  description = "The namespace where cert manager has been deployed"
  value       = var.namespace
  depends_on  = [null_resource.setup_gitops]
}
