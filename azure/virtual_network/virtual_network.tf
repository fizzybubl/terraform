resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = var.resource_group_name_prefix
}


resource "azurerm_virtual_network" "vnet" {
  name                = "vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  address_space = var.vnet_cidr_block
}


resource "azurerm_subnet" "public_subnet" {
  name = "public-subnet"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = [ "10.0.1.0/24" ]
}


resource "azurerm_subnet" "private_subnet" {
  name = "private-subnet"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  default_outbound_access_enabled = false
  address_prefixes = [ "10.0.2.0/24" ]
}


resource "azurerm_public_ip" "static_public" {
  name                = "public-ip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku = "Standard"
  zones = ["1"]

  tags = {
    environment = "Production"
  }
}


resource "azurerm_nat_gateway" "nat" {
  name                    = "nat-gateway"
  location                = azurerm_resource_group.rg.location
  resource_group_name     = azurerm_resource_group.rg.name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  zones                   = ["1"]
}


resource "azurerm_nat_gateway_public_ip_association" "example" {
  nat_gateway_id       = azurerm_nat_gateway.nat.id
  public_ip_address_id = azurerm_public_ip.static_public.id
}