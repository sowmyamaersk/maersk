
# Create Network Security Group and rule
resource "azurerm_network_security_group" "nsg" {
    count               = "${length(keys(local.nsgrules))}" 
    name                = var.nsg
    location            = var.location
   resource_group_name  = var.resgrp

    security_rule {
        name                       = "${lookup(local.nsgrules[element(keys(local.nsgrules), count.index)], "name")}"
        priority                   = "${lookup(local.nsgrules[element(keys(local.nsgrules), count.index)], "priority")}"
        direction                  = "${lookup(local.nsgrules[element(keys(local.nsgrules), count.index)], "direction")}"
        access                     = "${lookup(local.nsgrules[element(keys(local.nsgrules), count.index)], "access")}"
        protocol                   = "${lookup(local.nsgrules[element(keys(local.nsgrules), count.index)], "protocol")}"
        source_port_range          ="${lookup(local.nsgrules[element(keys(local.nsgrules), count.index)], "source_port_range")}"
        destination_port_range     = "${lookup(local.nsgrules[element(keys(local.nsgrules), count.index)], "destination_port_range")}"
        source_address_prefix      = "${lookup(local.nsgrules[element(keys(local.nsgrules), count.index)], "source_address_prefix")}"
        destination_address_prefix = "${lookup(local.nsgrules[element(keys(local.nsgrules), count.index)], "destination_address_prefix")}"
    }
}


