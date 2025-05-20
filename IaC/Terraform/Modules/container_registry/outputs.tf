output "acr_name" {
  description = "Specifies the name of the container registry."
  value       = azurerm_container_registry.this.name
}

output "acr_id" {
  description = "Specifies the resource id of the container registry."
  value       = azurerm_container_registry.this.id
}


output "acr_login_server" {
  description = "Specifies the login server of the container registry."
  value       = azurerm_container_registry.this.login_server
}

output "acr_login_server_url" {
  description = "Specifies the login server url of the container registry."
  value       = "https://${azurerm_container_registry.this.login_server}"
}

output "admin_username" {
  description = "Specifies the admin username of the container registry."
  value       = azurerm_container_registry.this.admin_username
}
