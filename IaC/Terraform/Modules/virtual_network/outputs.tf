output "vnet_name" {
  value = azurerm_virtual_network.this.name
}

output "vnet_id" {
  value = azurerm_virtual_network.this.id
}

output "aks_subnet_name" {
  value = azurerm_subnet.aks.name
}

output "aks_subnet_id" {
  value = azurerm_subnet.aks.id
}

output "nodepool_subnet_name" {
  value = azurerm_subnet.nodepool.name
}

output "nodepool_subnet_id" {
  value = azurerm_subnet.nodepool.id
}

output "appgw_subnet_name" {
  value = azurerm_subnet.appgw.name
}

output "appgw_subnet_id" {
  value = azurerm_subnet.appgw.id
}
