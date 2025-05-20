variable "kv_name" {
  description = "(Required) Specifies the name of the key vault."
  type        = string
}

variable "resource_group_name" {
  description = "(Required) Specifies the resource group name of the key vault."
  type        = string
}

variable "location" {
  description = "(Required) Specifies the location where the key vault will be deployed."
  type        = string
}

variable "tenant_id" {
  description = "(Required) The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault."
  type        = string
}

variable "object_id" {
  description = "(Required) object that should be used for authenticating requests to the key vault."
  type        = string
}

variable "kv_sku_name" {
  description = "(Required) The Name of the SKU used for this Key Vault. Possible values are standard and premium."
  type        = string

  validation {
    condition     = contains(["standard", "premium"], var.kv_sku_name)
    error_message = "The value of the sku name property of the key vault is invalid."
  }
}

variable "purge_protection_enabled" {
  description = "(Optional) Is Purge Protection enabled for this Key Vault? Defaults to false."
  type        = bool
}

variable "soft_delete_retention_days" {
  description = "(Optional) The number of days that items should be retained for once soft-deleted. This value can be between 7 and 90 (the default) days."
  type        = number
}

variable "tags" {
  description = "(Optional) Specifies the tags of the log analytics workspace"
  type        = map(string)
}


variable "enable_rbac_authorization" {
  description = "(Optional) Boolean flag to specify whether Azure Key Vault uses Role Based Access Control (RBAC) for authorization of data actions. Defaults to false."
  type        = bool
}
