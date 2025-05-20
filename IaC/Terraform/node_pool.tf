module "node_pool" {
  source                 = "./Modules/node_pool/"
  node_pool_name         = local.node_pool_name
  resource_group_name    = local.resourceGroupName
  location               = local.location
  kubernetes_cluster_id  = module.aks.kubernetes_cluster_id
  vm_size                = local.vm_size
  availability_zones     = local.availability_zones
  enable_auto_scaling    = local.enable_auto_scaling
  enable_host_encryption = local.enable_host_encryption
  enable_node_public_ip  = local.enable_node_public_ip
  max_pods               = local.max_pods
  mode                   = local.mode
  node_count             = local.node_count
  os_disk_size_gb        = local.os_disk_size_gb
  os_disk_type           = local.os_disk_type
  os_type                = local.os_type
  priority               = local.priority
  vnet_subnet_id         = module.vnet.nodepool_subnet_id
  max_count              = local.max_count
  min_count              = local.min_count
  oidc_issuer_enabled    = local.node_pool_oidc_issuer_enabled
  tags                   = local.default_tags
  depends_on = [module.vnet, module.aks, module.acr]
}






