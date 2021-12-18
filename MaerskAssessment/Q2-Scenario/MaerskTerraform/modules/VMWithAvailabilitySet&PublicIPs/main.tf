
resource "azurerm_resource_group" "resgrp" {
 name     = var.resgrp
 location = var.location
}

resource "azurerm_virtual_network" "vnet" {
 name                = var.vnet-name
 address_space       = ["10.1.0.0/24"]
 location            = azurerm_resource_group.resgrp.location
 resource_group_name = azurerm_resource_group.resgrp.name
 tags= var.tags
}

resource "azurerm_subnet" "subnet" {
 name                 = var.subnet-name
 resource_group_name  = azurerm_resource_group.resgrp.name
 virtual_network_name = azurerm_virtual_network.vnet.name
 address_prefix       = "10.1.0.0/24"
}
resource "azurerm_public_ip" "vmpip" {
  count               = var.countvalue
  name                = "edocs-${count.index}-pip"
  location                     = azurerm_resource_group.resgrp.location
 resource_group_name          = azurerm_resource_group.resgrp.name
 allocation_method            = "Static"
}
resource "azurerm_public_ip" "elb-lb-pip" {
 name                         = var.lb-pip-name
 location                     = azurerm_resource_group.resgrp.location
 resource_group_name          = azurerm_resource_group.resgrp.name
 allocation_method            = "Static"
}
resource "azurerm_lb" "ELB" {
 name                = var.lb-name
 location            = azurerm_resource_group.resgrp.location
 resource_group_name = azurerm_resource_group.resgrp.name

 frontend_ip_configuration {
   name                 = var.lb-pip-name
   public_ip_address_id = azurerm_public_ip.elb-lb-pip.id
 }
}

resource "azurerm_lb_backend_address_pool" "backendpool-name" {
 resource_group_name = azurerm_resource_group.resgrp.name
 loadbalancer_id     = azurerm_lb.ELB.id
 name                = var.backendpool-name
}

# Create Network Security Group and rule

resource "azurerm_network_security_group" "nsg" {
    count               = "${length(keys(local.nsgrules))}" 
    name                = var.nsg
 location             = azurerm_resource_group.resgrp.location
 resource_group_name  = azurerm_resource_group.resgrp.name


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

resource "azurerm_network_interface" "nic" {
 count               = var.countvalue
 name                = "edocs${count.index}nic"
 location            = azurerm_resource_group.resgrp.location
 resource_group_name = azurerm_resource_group.resgrp.name

 ip_configuration {
   name                          = var.nicipname
   subnet_id                     = azurerm_subnet.subnet.id
   private_ip_address_allocation = "dynamic"
  public_ip_address_id           = element(azurerm_public_ip.vmpip.*.id, count.index)
   
 }
 depends_on = [azurerm_public_ip.vmpip]
}

resource "azurerm_network_interface_backend_address_pool_association" "nic-associate" {
     count               = var.countvalue
    network_interface_id      = element(azurerm_network_interface.nic.*.id, count.index)
     ip_configuration_name   = var.nicipname
    backend_address_pool_id = azurerm_lb_backend_address_pool.backendpool-name.id
}
 #Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "nsg-associate" {
    count               = var.countvalue  
     network_interface_id      = element(azurerm_network_interface.nic.*.id, count.index)  
   network_security_group_id = element(azurerm_network_security_group.nsg.*.id, count.index)
   depends_on = [azurerm_network_interface.nic]
}


resource "azurerm_managed_disk" "vmmanageddisk" {
 count                = var.countvalue
 name                 = "datadisk_${count.index}"
 location             = azurerm_resource_group.resgrp.location
 resource_group_name  = azurerm_resource_group.resgrp.name
 storage_account_type = var.disk-storage-account-type
 create_option        = "Empty"
 disk_size_gb         = var.disk_size_gb 
}

resource "azurerm_availability_set" "avset" {
  name                         = var.avset
 location             = azurerm_resource_group.resgrp.location
 resource_group_name  = azurerm_resource_group.resgrp.name
 platform_fault_domain_count  = 2
 platform_update_domain_count = 3
 managed                      = true
}

resource "azurerm_virtual_machine" "vm" {
 count                 = var.countvalue
 name                  = "AENet-Edocs-VM${count.index}"
 location              = azurerm_resource_group.resgrp.location
 availability_set_id   = azurerm_availability_set.avset.id
//availability_set_id    = element(azurerm_availability_set.avset.*.id, count.index)

 resource_group_name   = azurerm_resource_group.resgrp.name
 network_interface_ids = [element(azurerm_network_interface.nic.*.id, count.index)]
 vm_size               = var.vm_size

 # Uncomment this line to delete the OS disk automatically when deleting the VM
 delete_os_disk_on_termination = true

 # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = var.vm_image_publisher
    offer = var.vm_image_offer
    sku = var.vm_image_sku
    version = var.vm_image_version
    }

 storage_os_disk {
   name              = "myosdisk${count.index}"
   caching           = "ReadWrite"
   create_option     = "FromImage"
   managed_disk_type = "Standard_LRS"
 }


 os_profile {
   computer_name  = "EdocsHostname${count.index}"
   admin_username = var.VM_ADMIN
   admin_password = var.VM_PASSWORD
 }

    os_profile_windows_config {
    provision_vm_agent = "true"
    enable_automatic_upgrades = "true"
    winrm {
    protocol = "http"
    certificate_url =""
}
}
}