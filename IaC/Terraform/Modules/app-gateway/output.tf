output "public_ip_address" {
  value = azurerm_public_ip.this.ip_address
}

output "public_ip_address_id" {
  value = azurerm_public_ip.this.id
}

output "appGateway_name" {
  value = azurerm_application_gateway.this.name
}

output "appGateway_id" {
  value = azurerm_application_gateway.this.id
}

# output "appgw_identity" {
#   value = azurerm_application_gateway.this.identity.0.principal_id
# }