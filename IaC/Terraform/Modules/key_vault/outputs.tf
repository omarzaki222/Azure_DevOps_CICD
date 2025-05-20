output "kv_name" {
  value       = azurerm_key_vault.this.name
  description = "Specifies the name of the key vault."
}

output "kv_id" {
  value       = azurerm_key_vault.this.id
  description = "Specifies the resource id of the key vault."
}


output "key_vault_url" {
  value = azurerm_key_vault.this.vault_uri
}