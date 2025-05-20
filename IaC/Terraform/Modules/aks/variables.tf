
variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Location"
  type        = string
}

variable "tags" {
  type = map(string)
}

variable "aks_administrators_group_id" {
  description = "Azure AKS Kubernetes administrators for the enterprise-eks-dev."
  type        = string
}


variable "aks_name" {
  description = "(Required) Specifies the name of the AKS cluster."
  type        = string
}

variable "dns_prefix" {
  description = "(Optional) DNS prefix specified when creating the managed cluster. Changing this forces a new resource to be created."
  type        = string
}

variable "private_cluster_enabled" {
  description = "Should this Kubernetes Cluster have its API server only exposed on internal IP addresses? This provides a Private IP Address for the Kubernetes API on the Virtual Network where the Kubernetes Cluster is located. Defaults to false. Changing this forces a new resource to be created."
  type        = bool
}

variable "automatic_channel_upgrade" {
  description = "(Optional) The upgrade channel for this Kubernetes Cluster. Possible values are patch, rapid, and stable."
  type        = string

  validation {
    condition     = contains(["patch", "rapid", "stable"], var.automatic_channel_upgrade)
    error_message = "The upgrade mode is invalid."
  }
}

variable "sku_tier" {
  description = "(Optional) The SKU Tier that should be used for this Kubernetes Cluster. Possible values are Free and Paid (which includes the Uptime SLA). Defaults to Free."
  default     = "Standard"
  type        = string

  validation {
    condition     = contains(["Free", "Standard", "Paid"], var.sku_tier)
    error_message = "The sku tier is invalid."
  }
}

variable "workload_identity_enabled" {
  description = "(Optional) Specifies whether Azure AD Workload Identity should be enabled for the Cluster. Defaults to false."
  type        = bool
}

variable "oidc_issuer_enabled" {
  description = "(Optional) Enable or Disable the OIDC issuer URL."
  type        = bool
}

# variable "open_service_mesh_enabled" {
#   description = "(Optional) To allows Microsoft Entra ID or other cloud provider identity and access management platform, to discover the API server's public signing keys."
#   type        = bool
# }

variable "image_cleaner_enabled" {
  description = "(Optional) Specifies whether Image Cleaner is enabled."
  type        = bool
}


variable "azure_policy_enabled" {
  description = "(Optional) Azure Policy makes it possible to manage and report on the compliance state of your Kubernetes cluster components from one place"
  type        = bool
}

variable "http_application_routing_enabled" {
  description = "(Optional) Should HTTP Application Routing be enabled?"
  type        = bool
}

# variable "disk_encryption_set_id" {
#   type        = string
#   description = "(Optional) The ID of the Disk Encryption Set which should be used for the Nodes and Volumes. More information [can be found in the documentation](https://docs.microsoft.com/azure/aks/azure-disk-customer-managed-keys). Changing this forces a new resource to be created."
# }


variable "role_based_access_control_enabled" {
  type        = bool
  description = "Enable Role Based Access Control."
  nullable    = false
}

variable "admin_username" {
  description = "(Required) Specifies the Admin Username for the AKS cluster worker nodes. Changing this forces a new resource to be created."
  type        = string
}

# variable "client_id" {
#   description = "(Required) The Client ID for the Service Principal."
#   type        = string
# }

# variable "client_secret" {
#   description = "(Required) The Client Secret for the Service Principal."
#   type        = string
# }

variable "identity_type" {
  type        = string
  description = "(Optional) The type of identity used for the managed cluster. Conflicts with `client_id` and `client_secret`. Possible values are `SystemAssigned` and `UserAssigned`. If `UserAssigned` is set, an `identity_ids` must be set as well."

  validation {
    condition     = var.identity_type == "SystemAssigned" || var.identity_type == "UserAssigned"
    error_message = "`identity_type`'s possible values are `SystemAssigned` and `UserAssigned`"
  }
}

variable "local_account_disabled" {
  description = "(Optional) If true local accounts will be disabled"
  type        = bool
}

variable "azure_rbac_enabled" {
  description = "(Optional) Is Role Based Access Control based on Azure AD enabled?"
  type        = bool
}

# variable "tenant_id" {
#   description = "tenant id"
#   type        = string
# }

variable "key_vault_secrets_provider" {
  description = "Enable CSI driver to access key vault"
  type        = bool
}

variable "secret_rotation_enabled" {
  description = "Update the secrets on a regular basis"
  type        = bool
}

variable "default_node_pool_name" {
  description = "Specifies the name of the default node pool"
  type        = string
}

variable "vnet_subnet_id" {
  description = "(Optional) The ID of a Subnet where the Kubernetes Node Pool should exist. Changing this forces a new resource to be created."
  type        = string
}


variable "default_node_pool_subnet_name" {
  description = "Specifies the name of the subnet that hosts the default node pool"
  type        = string
}


variable "default_node_pool_enable_auto_scaling" {
  description = "(Optional) Whether to enable auto-scaler. Defaults to false."
  type        = bool
}

variable "default_node_pool_enable_host_encryption" {
  description = "(Optional) Should the nodes in this Node Pool have host encryption enabled? Defaults to false."
  type        = bool
}

variable "default_node_pool_enable_node_public_ip" {
  description = "(Optional) Should each node have a Public IP Address? Defaults to false. Changing this forces a new resource to be created."
  type        = bool
}

variable "default_node_pool_max_pods" {
  description = "(Optional) The maximum number of pods that can run on each agent. Changing this forces a new resource to be created."
  type        = number
}

variable "default_node_pool_node_labels" {
  description = "(Optional) A list of Kubernetes taints which should be applied to nodes in the agent pool (e.g key=value:NoSchedule). Changing this forces a new resource to be created."
  type        = map(any)
}

variable "default_node_pool_os_disk_type" {
  description = "(Optional) The type of disk which should be used for the Operating System. Possible values are Ephemeral and Managed. Defaults to Managed. Changing this forces a new resource to be created."
  type        = string
}

variable "default_node_pool_max_count" {
  description = "(Required) The maximum number of nodes which should exist within this Node Pool. Valid values are between 0 and 1000 and must be greater than or equal to min_count."
  type        = number
}

variable "default_node_pool_min_count" {
  description = "(Required) The minimum number of nodes which should exist within this Node Pool. Valid values are between 0 and 1000 and must be less than or equal to max_count."
  type        = number
}

variable "default_node_pool_node_count" {
  description = "(Optional) The initial number of nodes which should exist within this Node Pool. Valid values are between 0 and 1000 and must be a value in the range min_count - max_count."
  type        = number
}

variable "default_node_pool_vm_size" {
  description = "Specifies the vm size of the default node pool"
  type        = string
}


variable "default_node_pool_availability_zones" {
  description = "Specifies the availability zones of the default node pool"
  type        = list(string)
}

variable "network_plugin" {
  description = "Specifies the network plugin of the AKS cluster"
  type        = string
}

variable "loadbalancerSku" {
  description = "Specifies the network plugin of the AKS cluster"
  type        = string
}


### Ingress Application Gateway
variable "ingress_application_gateway_enabled" {
  type        = bool
  description = "Whether to deploy the Application Gateway ingress controller to this Kubernetes Cluster?"
}

# variable "ingress_application_gateway_id" {
#   type        = string
#   description = "The ID of the Application Gateway to integrate with the ingress controller of this Kubernetes Cluster."
# }

variable "ingress_application_gateway_name" {
  type        = string
  description = "The name of the Application Gateway to be used or created in the Nodepool Resource Group, which in turn will be integrated with the ingress controller of this Kubernetes Cluster."
}


variable "ingress_application_gateway_subnet_id" {
  type        = string
  description = "The ID of the subnet on which to create an Application Gateway, which in turn will be integrated with the ingress controller of this Kubernetes Cluster."
}


# variable "ingress_application_gateway_subnet_cidr" {
#   type        = string
#   description = "The subnet CIDR to be used to create an Application Gateway, which in turn will be integrated with the ingress controller of this Kubernetes Cluster."
# }


variable "pipelineURI" {
  description = "The ADO pipeline URL"
  type        = string
  default     = ""
}
