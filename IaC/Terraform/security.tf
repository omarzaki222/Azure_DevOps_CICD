# Grant AKS access to ACR Dev ----------------
resource "azurerm_role_assignment" "acr" {
  principal_id         = module.aks.aks_object_id
  role_definition_name = "AcrPull"
  scope                = module.acr.acr_id
  depends_on           = [module.acr, module.aks]
}


# Grant App Gateway access to vNet ----------------
resource "azurerm_role_assignment" "appgw" {
  principal_id         = module.aks.app_gateway_id
  role_definition_name = "Contributor"
  scope                = module.vnet.vnet_id
  depends_on           = [module.vnet, module.aks]
}

# Grant admins access to AKS ----------------
resource "azurerm_role_assignment" "aks_admin" {
  scope                = module.aks.kubernetes_cluster_id
  role_definition_name = "Contributor"
  principal_id         = local.aks_administrators_group_id
  depends_on           = [module.aks]
}

# Grant sp access to AKS ----------------
resource "azurerm_role_assignment" "aks_rg" {
  scope                = data.azurerm_resource_group.current.id
  role_definition_name = "Contributor"
  principal_id         = module.aks.aks_object_id
  depends_on           = [module.aks]
}

# Grant SP access to akv ----------------
resource "azurerm_role_assignment" "sp" {
  scope                = module.kv.kv_id
  role_definition_name = "Key Vault Administrator"
  principal_id         = local.aks_administrators_group_id
  depends_on           = [module.aks, module.kv]
}

# Create a user account for AKS to access AKV secrets ----------------
resource "azurerm_user_assigned_identity" "this" {
  name                = "enterpriseuserid"
  location            = local.location
  resource_group_name = local.resourceGroupName

  depends_on = [module.aks, module.kv, module.vnet]
}

# Grant permissions for user assigned id to akv secrets
resource "azurerm_role_assignment" "aks_kv_secret_access" {
  scope                = module.kv.kv_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.this.principal_id
  depends_on           = [module.aks, module.kv, module.vnet, azurerm_user_assigned_identity.this]
}


# Grant permissions for user assigned id to akv certs
resource "azurerm_role_assignment" "aks_kv_cert_access" {
  scope                = module.kv.kv_id
  role_definition_name = "Key Vault Certificates Officer"
  principal_id         = azurerm_user_assigned_identity.this.principal_id
  depends_on           = [module.aks, module.kv, module.vnet, azurerm_user_assigned_identity.this]
}

# Grant permissions for user assigned id to dev acr 
resource "azurerm_role_assignment" "aks_acr_access" {
  scope                = module.acr.acr_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.this.principal_id
  depends_on           = [module.aks, module.acr, module.vnet, azurerm_user_assigned_identity.this]
}



