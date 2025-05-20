
data "azuread_client_config" "current" {}

data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}

data "azurerm_resource_group" "current" {
  name = local.resourceGroupName
}
