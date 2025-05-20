module "kv" {
  source                     = "./Modules/key_vault/"
  kv_name                    = local.kv_name
  resource_group_name        = local.resourceGroupName
  location                   = local.location
  tenant_id                  = local.tenant_id
  object_id                  = local.client_id
  kv_sku_name                = local.kv_sku
  purge_protection_enabled   = local.purge_protection_enabled
  soft_delete_retention_days = local.soft_delete_retention_days
  enable_rbac_authorization  = local.enable_rbac_authorization
  tags                       = local.default_tags
  depends_on                 = [module.vnet, module.aks]
}


resource "azurerm_key_vault_access_policy" "aks" {
  key_vault_id = module.kv.kv_id
  tenant_id    = var.tenant_id
  object_id    = azurerm_user_assigned_identity.this.client_id
  # cluster access to secrets should be read-only
  key_permissions = [
    "Get", "List"
  ]
  secret_permissions = [
    "Get", "List"
  ]
  certificate_permissions = [
    "Get", "List"
  ]
  depends_on = [module.vnet, module.kv, module.aks, azurerm_user_assigned_identity.this]
}

