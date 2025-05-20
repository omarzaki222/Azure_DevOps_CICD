variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Location"
  type        = string
  default     = "East US"
}

variable "tags" {
  type = map(string)
}


variable "pipelineURI" {
  description = "The ADO pipeline URL"
  type        = string
  default     = ""
}