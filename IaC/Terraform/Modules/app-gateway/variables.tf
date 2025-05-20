variable "resource_group_name" {
  description = "Resource Group name"
  type        = string
}

variable "location" {
  description = "Location in which to deploy the network"
  type        = string
  default     = "East US"
}

variable "appGateway_name" {
  type        = string
  description = "application gateway name"
}

variable "publicIp_name" {
  type        = string
  description = "Public IP Name"
}

variable "allocation_method" {
  type        = string
  description = "Allocation Method"
}

variable "sku_name" {
  description = "(Required) The Name of the SKU to use for this Application Gateway. Possible values are Standard_Small, Standard_Medium, Standard_Large, Standard_v2, WAF_Medium, WAF_Large, and WAF_v2"
  type        = string
}

variable "ipSku_tier" {
  description = " (Optional) The SKU of the Public IP. Accepted values are Basic and Standard. Defaults to Basic. Changing this forces a new resource to be created."
  type        = string
}

variable "sku_tier" {
  type        = string
  description = "(Required) The Tier of the SKU to use for this Application Gateway. Possible values are Standard, Standard_v2, WAF and WAF_v2"
}

variable "sku_capacity" {
  type        = string
  description = "(Optional) The Capacity of the SKU to use for this Application Gateway. When using a V1 SKU this value must be between 1 and 32, and 1 to 125 for a V2 SKU. This property is optional if autoscale_configuration is set."
}

variable "vnet_name" {
  description = "VNET name"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID"
  type        = string
}

variable "subnet_name" {
  description = "Subnet Name"
  type        = string
}

# variable "identity_ids" {
#   description = "A list of Managed Service Identity IDs which should be associated with the Application Gateway. Possible values are SystemAssigned and UserAssigned."
#   type        = list(string)

# }

variable "tags" {
  type = map(string)
}


variable "pipelineURI" {
  description = "The ADO pipeline URL"
  type        = string
  default     = ""
}