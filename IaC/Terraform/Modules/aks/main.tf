
# Datasource to get Latest Azure AKS latest Version
data "azurerm_kubernetes_service_versions" "current" {
  location        = var.location
  include_preview = false
}

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "azurerm_kubernetes_cluster" "this" {
  name                      = var.aks_name
  location                  = var.location
  resource_group_name       = var.resource_group_name
  kubernetes_version        = data.azurerm_kubernetes_service_versions.current.latest_version
  dns_prefix                = var.dns_prefix
  private_cluster_enabled   = var.private_cluster_enabled
  automatic_channel_upgrade = var.automatic_channel_upgrade
  sku_tier                  = var.sku_tier
  workload_identity_enabled = var.workload_identity_enabled
  oidc_issuer_enabled       = var.oidc_issuer_enabled
  local_account_disabled    = var.local_account_disabled
  # open_service_mesh_enabled         = var.open_service_mesh_enabled
  image_cleaner_enabled             = var.image_cleaner_enabled
  azure_policy_enabled              = var.azure_policy_enabled
  http_application_routing_enabled  = var.http_application_routing_enabled
  role_based_access_control_enabled = var.role_based_access_control_enabled

  default_node_pool {
    name                   = var.default_node_pool_name
    vm_size                = var.default_node_pool_vm_size
    vnet_subnet_id         = var.vnet_subnet_id
    zones                  = var.default_node_pool_availability_zones
    node_labels            = var.default_node_pool_node_labels
    enable_auto_scaling    = var.default_node_pool_enable_auto_scaling
    enable_host_encryption = var.default_node_pool_enable_host_encryption
    enable_node_public_ip  = var.default_node_pool_enable_node_public_ip
    max_pods               = var.default_node_pool_max_pods
    max_count              = var.default_node_pool_max_count
    min_count              = var.default_node_pool_min_count
    node_count             = var.default_node_pool_node_count
    os_disk_type           = var.default_node_pool_os_disk_type
    tags                   = var.tags
  }

  linux_profile {
    admin_username = var.admin_username
    ssh_key {
      key_data = tls_private_key.ssh.public_key_openssh
    }
  }


  # service_principal {
  #   client_id     = var.client_id
  #   client_secret = var.client_secret
  # }

  identity {
    type = var.identity_type
  }


  network_profile {
    network_plugin    = var.network_plugin
    load_balancer_sku = var.loadbalancerSku
  }


  azure_active_directory_role_based_access_control {
    managed            = true
    azure_rbac_enabled = var.azure_rbac_enabled
    # tenant_id              = var.tenant_id
    admin_group_object_ids = [var.aks_administrators_group_id]
  }

  dynamic "ingress_application_gateway" {
    for_each = var.ingress_application_gateway_enabled ? ["ingress_application_gateway"] : []

    content {
      # gateway_id   = var.ingress_application_gateway_id
      gateway_name = var.ingress_application_gateway_name
      subnet_id    = var.ingress_application_gateway_subnet_id
      # subnet_cidr = var.ingress_application_gateway_subnet_cidr
    }
  }

  dynamic "key_vault_secrets_provider" {
    for_each = var.key_vault_secrets_provider ? ["key_vault_secrets_provider"] : []

    content {
      secret_rotation_enabled = var.secret_rotation_enabled
    }
  }


  tags = var.tags
}


