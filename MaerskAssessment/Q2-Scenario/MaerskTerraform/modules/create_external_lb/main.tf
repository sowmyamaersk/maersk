
resource "azurerm_public_ip" "lb_pip" {
 name                         = var.lb-pip-name
 location                     = var.location
 resource_group_name          =var.resgrp
 allocation_method            = "Static"
 //By default sku type is Basic,If you want Standard type please use below code
 sku                          ="Standard"
}

resource "azurerm_lb" "elb" {
 name                = var.lb-name
 location            = var.location
 resource_group_name = var.resgrp
  //By default sku type is Basic,If you want Standard type please use below code
   sku="Standard"

 frontend_ip_configuration {
   name                 = var.lb_frontend_ip_configuration_name
   public_ip_address_id = azurerm_public_ip.lb_pip.id
  
 }
}

resource "azurerm_lb_backend_address_pool" "backendpool" {
 resource_group_name = var.resgrp
 loadbalancer_id     = azurerm_lb.elb.id
 name                = var.backendpool-name

}

resource "azurerm_lb_probe" "lb-probe" {
  count                       = "${length(keys(local.lbprobe))}" 
  resource_group_name = var.resgrp
  loadbalancer_id     = azurerm_lb.elb.id
  name                = "${lookup(local.lbprobe[element(keys(local.lbprobe), count.index)], "name")}"
  port                = "${lookup(local.lbprobe[element(keys(local.lbprobe), count.index)], "port")}"
  protocol            = "${lookup(local.lbprobe[element(keys(local.lbprobe), count.index)], "protocol")}"          
  interval_in_seconds = "${lookup(local.lbprobe[element(keys(local.lbprobe), count.index)], "interval_in_seconds")}"
  number_of_probes    = "${lookup(local.lbprobe[element(keys(local.lbprobe), count.index)], "number_of_probes")}"
}
 
resource "azurerm_lb_rule" "lb-rule" {
  count                       = "${length(keys(local.lbrules))}" 
  resource_group_name            = var.resgrp
  loadbalancer_id                = azurerm_lb.elb.id  
  backend_address_pool_id        =azurerm_lb_backend_address_pool.backendpool.id
  probe_id                       =azurerm_lb_probe.lb-probe[count.index].id
  name                           ="${lookup(local.lbrules[element(keys(local.lbrules), count.index)], "name")}"
  protocol                       = "${lookup(local.lbrules[element(keys(local.lbrules), count.index)], "protocol")}"
  frontend_port                  = "${lookup(local.lbrules[element(keys(local.lbrules), count.index)], "frontend_port")}"
  backend_port                   = "${lookup(local.lbrules[element(keys(local.lbrules), count.index)], "backend_port")}"
  frontend_ip_configuration_name = var.lb_frontend_ip_configuration_name
  
}

resource "azurerm_lb_nat_rule" "lb-natrule" {
  count                       = "${length(keys(local.lbnatrules))}"
  resource_group_name            = var.resgrp
  loadbalancer_id                = azurerm_lb.elb.id 
  name                           ="${lookup(local.lbnatrules[element(keys(local.lbnatrules), count.index)], "name")}"
  protocol                       = "${lookup(local.lbnatrules[element(keys(local.lbnatrules), count.index)], "protocol")}"
  frontend_port                  = "${lookup(local.lbnatrules[element(keys(local.lbnatrules), count.index)], "frontend_port")}"
  backend_port                   = "${lookup(local.lbnatrules[element(keys(local.lbnatrules), count.index)], "backend_port")}"
  frontend_ip_configuration_name = var.lb_frontend_ip_configuration_name
}


 