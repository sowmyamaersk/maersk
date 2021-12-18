 resource "azurerm_availability_set" "avset" {
 name                         = "${var.avset}"
 location                     ="${var.location}"
 resource_group_name          ="${var.resgrp}"
 platform_fault_domain_count  = "${var.fault-domain-count}"
 platform_update_domain_count = "${var.update-domain-count}"
 managed                      = true
}