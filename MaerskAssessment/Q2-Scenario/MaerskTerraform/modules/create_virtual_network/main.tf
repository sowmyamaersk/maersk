
resource "azurerm_virtual_network" "vnet" {
 name                = var.vnet-name
 address_space       = var.vnet-address-space
 location            = var.location
 resource_group_name =var.resgrp
 tags= var.tags
}

resource "azurerm_subnet" "subnet" {
 name                 = var.subnet-name
 resource_group_name  = var.resgrp
 virtual_network_name = azurerm_virtual_network.vnet.name
 address_prefix       = var.subnet-address-prefix
}