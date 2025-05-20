resource "azurerm_public_ip" "this" {
  name                = "${var.resource_group_name}-public-ip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = var.allocation_method
  sku                 = var.ipSku_tier
  tags                = var.tags
}

resource "azurerm_application_gateway" "this" {
  name                = "${var.resource_group_name}-app-gateway"
  resource_group_name = var.resource_group_name
  location            = var.location

  sku {
    name     = var.sku_name
    tier     = var.sku_tier
    capacity = var.sku_capacity
  }

  # identity {
  #   type         = "SystemAssigned"
  #   identity_ids = var.identity_ids
  # }

  gateway_ip_configuration {
    name      = var.subnet_name
    subnet_id = var.subnet_id
  }

  frontend_port {
    name = "${var.vnet_name}-feport"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "${var.vnet_name}-feip"
    public_ip_address_id = azurerm_public_ip.this.id
  }

  backend_address_pool {
    name = "${var.vnet_name}-be-pool"
  }

  backend_http_settings {
    name                  = "${var.vnet_name}-be-htst"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 1
  }

  http_listener {
    name                           = "${var.vnet_name}-httplstn"
    frontend_ip_configuration_name = "${var.vnet_name}-feip"
    frontend_port_name             = "${var.vnet_name}-feport"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "${var.vnet_name}-rqrt"
    priority                   = 9
    rule_type                  = "Basic"
    http_listener_name         = "${var.vnet_name}-httplstn"
    backend_address_pool_name  = "${var.vnet_name}-beap"
    backend_http_settings_name = "${var.vnet_name}-be-htst"
  }

  tags = var.tags
}