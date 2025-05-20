locals {
  projectName                 = var.projectName
  environment                 = var.environment
  location                    = var.location
  resourceGroupName           = var.resourceGroupName
  aks_administrators_group_id = var.aks_administrators_group_id
  client_id                   = var.client_id
  client_secret               = var.client_secret
  tenant_id                   = var.tenant_id
  subscription_id             = var.subscription_id
  region                      = var.region


  # Vnet configs
  vnet_name                 = "${var.projectName}-aks-${var.environment}-vnet"
  address_space             = ["10.0.0.0/12"]
  aks_subnet_name           = "${var.projectName}-aks-${var.environment}-subnet"
  aks_address_prefixes      = ["10.1.0.0/16"]
  nodepool_subnet_name      = "${var.projectName}-aks-${var.environment}-nodepool-subnet"
  nodepool_address_prefixes = ["10.2.0.0/16"]
  appgw_subnet_name         = "${var.projectName}-appgw-${var.environment}-subnet"
  appgw_address_prefixes    = ["10.3.0.0/16"]

  # ACR configs
  acr_name      = "${var.projectName}Acr"
  admin_enabled = true
  acr_sku       = "Standard"

  # Key Vault configs
  kv_name                    = "${var.projectName}-aks-${var.environment}-kv"
  kv_sku                     = "standard"
  purge_protection_enabled   = true
  enable_rbac_authorization  = true
  soft_delete_retention_days = 7

  # AKS configs
  aks_name                                 = "${var.projectName}-aks-${var.environment}"
  dns_prefix                               = "rg-aks-${var.environment}"
  private_cluster_enabled                  = false
  automatic_channel_upgrade                = "stable"
  aks_sku_tier                             = "Standard"
  workload_identity_enabled                = true
  oidc_issuer_enabled                      = true
  open_service_mesh_enabled                = false
  image_cleaner_enabled                    = true
  azure_policy_enabled                     = false
  http_application_routing_enabled         = true
  identity_type                            = "SystemAssigned"
  role_based_access_control_enabled        = true
  key_vault_secrets_provider               = true # disable csi driver
  secret_rotation_enabled                  = true
  admin_username                           = "azure"
  azure_rbac_enabled                       = false
  local_account_disabled                   = true
  default_node_pool_name                   = "system"
  default_node_pool_subnet_name            = "SystemSubnet"
  default_node_pool_enable_auto_scaling    = true
  default_node_pool_enable_host_encryption = false
  default_node_pool_enable_node_public_ip  = false
  default_node_pool_max_count              = 10
  default_node_pool_min_count              = 2
  default_node_pool_node_count             = 2
  default_node_pool_vm_size                = "Standard_DS2_v2"
  default_node_pool_availability_zones     = ["1", "2"]
  default_node_pool_max_pods               = 50
  default_node_pool_node_labels = {
    system = "true"
  }
  default_node_pool_os_disk_type      = "Managed"
  network_plugin                      = "azure"
  loadbalancerSku                     = "standard"
  ingress_application_gateway_enabled = true
  ingress_application_gateway_name    = "${var.projectName}-aks-${var.environment}-app-gateway"




  # Node Pool configs
  node_pool_name                = var.projectName
  vm_size                       = "Standard_D2_v2"
  availability_zones            = ["1", "2"]
  enable_auto_scaling           = true
  enable_host_encryption        = false
  enable_node_public_ip         = false
  max_pods                      = 250
  mode                          = "User"
  node_count                    = 2
  os_disk_size_gb               = 30
  os_disk_type                  = "Managed"
  os_type                       = "Linux"
  priority                      = "Regular"
  max_count                     = 10
  min_count                     = 2
  node_pool_oidc_issuer_enabled = true



  default_tags = {
    Application = var.projectName
    Environment = var.environment
    Owner       = "DevSecOps"
    CreatedBy   = "DevSecOps - AbdElrahman Zaki"
  }
}













