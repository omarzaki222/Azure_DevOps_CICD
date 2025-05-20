
variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create the storage account. Changing this forces a new resource to be created."
}

variable "storage_account_name" {
  type        = string
  description = "(Required) The name of the Storage Account where the Container should be created. Changing this forces a new resource to be created."
}

variable "location" {
  type        = string
  description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
  default     = "East US"
}

variable "account_tier" {
  type        = string
  description = "(Required) Defines the Tier to use for this storage account. Valid options are Standard and Premium. For BlockBlobStorage and FileStorage accounts only Premium is valid. Changing this forces a new resource to be created."
}

variable "account_replication_type" {
  type        = string
  description = "(Required) Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS"
}

variable "container_name" {
  type        = string
  description = "(Required) The name of the Container which should be created within the Storage Account. Changing this forces a new resource to be created."
}


variable "access_type" {
  type        = string
  description = "(Optional) The Access Level configured for this Container. Possible values are blob, container or private. Defaults to private"
}

variable "tags" {
  type = map(string)
}



variable "pipelineURI" {
  description = "The ADO pipeline URL"
  type        = string
  default     = ""
}
