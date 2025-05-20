output "aks_object_id" {
  value = azurerm_kubernetes_cluster.this.kubelet_identity[0].object_id
}

output "aks_name" {
  value = azurerm_kubernetes_cluster.this.name
}

output "aks_client_id" {
  value = azurerm_kubernetes_cluster.this.kubelet_identity[0].client_id
}

output "kubernetes_cluster_id" {
  value = azurerm_kubernetes_cluster.this.id
}

output "app_gateway_id" {
  value = azurerm_kubernetes_cluster.this.ingress_application_gateway[0].ingress_application_gateway_identity[0].object_id
}


output "aks_oicd_url" {
  value = azurerm_kubernetes_cluster.this.oidc_issuer_url
}

output "kube_config_raw" {
  value     = azurerm_kubernetes_cluster.this.kube_config_raw
  sensitive = true
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.this.kube_config
  sensitive = true
}


output "kube_config_host" {
  value     = azurerm_kubernetes_cluster.this.kube_config[0].host
  sensitive = true
}

output "kube_config_client_certificate" {
  value     = azurerm_kubernetes_cluster.this.kube_config[0].client_certificate
  sensitive = true
}

output "kube_config_cluster_ca_certificate" {
  value     = azurerm_kubernetes_cluster.this.kube_config[0].cluster_ca_certificate
  sensitive = true
}

output "kube_config_client_key" {
  value     = azurerm_kubernetes_cluster.this.kube_config[0].client_key
  sensitive = true
}

output "kube_config_username" {
  value     = azurerm_kubernetes_cluster.this.kube_config[0].username
  sensitive = true
}

output "kube_config_password" {
  value     = azurerm_kubernetes_cluster.this.kube_config[0].password
  sensitive = true
}

output "aks_identity_tenant_id" {
  value = azurerm_kubernetes_cluster.this.identity[0].tenant_id
}





# output "keyvault_provider" {
#   value = azurerm_kubernetes_cluster.this.key_vault_secrets_provider[0].secret_identity[0].object_id
# }