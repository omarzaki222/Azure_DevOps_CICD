module "acr" {
  source        = "./Modules/container_registry/"
  acr_name      = local.acr_name
  rg_name       = local.resourceGroupName
  location      = local.location
  admin_enabled = local.admin_enabled
  acr_sku       = local.acr_sku
  tags          = local.default_tags
  depends_on    = [module.vnet]
}




