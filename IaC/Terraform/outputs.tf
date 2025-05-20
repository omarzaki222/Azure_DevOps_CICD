output "vnet_name" {
  value = module.vnet.vnet_name
}

output "vnet_id" {
  value = module.vnet.vnet_id
}

output "aks_subnet_name" {
  value = module.vnet.aks_subnet_name
}

output "aks_subnet_id" {
  value = module.vnet.aks_subnet_id
}

output "nodepool_subnet_name" {
  value = module.vnet.nodepool_subnet_name
}

output "nodepool_subnet_id" {
  value = module.vnet.nodepool_subnet_id
}

output "appgw_subnet_name" {
  value = module.vnet.appgw_subnet_name
}

output "appgw_subnet_id" {
  value = module.vnet.appgw_subnet_id
}

output "app_gateway_id" {
  value = module.aks.app_gateway_id
}

output "aks_object_id" {
  value = module.aks.aks_object_id
}

output "aks_client_id" {
  value = module.aks.aks_client_id
}
output "kv_name" {
  value = module.kv.kv_name
}

output "kv_id" {
  value = module.kv.kv_id
}

output "key_vault_url" {
  value = module.kv.key_vault_url
}

output "secret_name" {
  value = data.azurerm_key_vault_secret.this.name
}


output "acr_name" {
  description = "Specifies the name of the container registry."
  value       = module.acr.acr_name
}

output "acr_id" {
  description = "Specifies the resource id of the container registry."
  value       = module.acr.acr_id
}

output "acr_login_server" {
  description = "Specifies the login server of the container registry."
  value       = module.acr.acr_login_server
}

output "acr_login_server_url" {
  description = "Specifies the login server url of the container registry."
  value       = "https://${module.acr.acr_login_server_url}"
}

output "acr_admin_username" {
  description = "Specifies the admin username of the container registry."
  value       = module.acr.admin_username
}


output "aks_oicd_url" {
  description = "Specifies the oidc issuer url of the aks cluster."
  value       = module.aks.aks_oicd_url
}

output "userAssignedID" {
  description = "Specifies the oidc issuer url of the aks cluster."
  value       = azurerm_user_assigned_identity.this.client_id
}

output "userAssignedName" {
  description = "Specifies the oidc issuer url of the aks cluster."
  value       = azurerm_user_assigned_identity.this.name
}

output "application_gateway_public_ip" {
  value = data.azurerm_public_ip.appwg_ip.ip_address
}

output "aks_identity_tenant_id" {
  value = module.aks.aks_identity_tenant_id
}

