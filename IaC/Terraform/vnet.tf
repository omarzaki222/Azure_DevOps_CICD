module "vnet" {
  source                    = "./Modules/virtual_network/"
  resource_group_name       = local.resourceGroupName
  location                  = local.location
  vnet_name                 = local.vnet_name
  address_space             = local.address_space
  aks_subnet_name           = local.aks_subnet_name
  aks_address_prefixes      = local.aks_address_prefixes
  nodepool_subnet_name      = local.nodepool_subnet_name
  nodepool_address_prefixes = local.nodepool_address_prefixes
  appgw_subnet_name         = local.appgw_subnet_name
  appgw_address_prefixes    = local.appgw_address_prefixes
  pipelineURI               = var.pipelineURI
  tags                      = local.default_tags
}