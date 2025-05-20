# Datasource to get Latest Azure AKS latest Version
data "azurerm_kubernetes_service_versions" "current" {
  location        = var.location
  include_preview = false
}

resource "azurerm_kubernetes_cluster_node_pool" "node_pool" {
  kubernetes_cluster_id  = var.kubernetes_cluster_id
  name                   = var.node_pool_name
  vm_size                = var.vm_size
  mode                   = var.mode
  zones                  = var.availability_zones
  vnet_subnet_id         = var.vnet_subnet_id
  enable_auto_scaling    = var.enable_auto_scaling
  enable_host_encryption = var.enable_host_encryption
  enable_node_public_ip  = var.enable_node_public_ip
  orchestrator_version   = data.azurerm_kubernetes_service_versions.current.latest_version
  max_pods               = var.max_pods
  max_count              = var.max_count
  min_count              = var.min_count
  node_count             = var.node_count
  os_disk_size_gb        = var.os_disk_size_gb
  os_disk_type           = var.os_disk_type
  os_type                = var.os_type
  priority               = var.priority
  # node_labels                  = var.node_labels
  # node_taints                  = var.node_taints
  tags = var.tags
}