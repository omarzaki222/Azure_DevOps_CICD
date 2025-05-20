variable "resource_group_name" {
  description = "Resource Group name"
  type        = string
}

variable "location" {
  description = "Location in which to deploy the network"
  type        = string
}

variable "vnet_name" {
  description = "VNET name"
  type        = string
}

variable "address_space" {
  description = "VNET address space"
  type        = list(string)
}

variable "aks_subnet_name" {
  description = "Subnets Name"
  type        = string
}

variable "aks_address_prefixes" {
  description = "Subnet Address Prefix"
  type        = list(string)
}

variable "appgw_subnet_name" {
  description = "Subnets Name"
  type        = string
}

variable "appgw_address_prefixes" {
  description = "Subnet Address Prefix"
  type        = list(string)
}

variable "nodepool_subnet_name" {
  description = "Subnets Name"
  type        = string
}

variable "nodepool_address_prefixes" {
  description = "value of the address prefix"
  type        = list(string)
}



variable "tags" {
  type = map(string)
}


variable "pipelineURI" {
  description = "The ADO pipeline URL"
  type        = string
  default     = ""
}