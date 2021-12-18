
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

 #Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "nsg-associate" {
    count               = var.countvalue  
     network_interface_id      = element(azurerm_network_interface.nic.*.id, count.index)  
   network_security_group_id = element(azurerm_network_security_group.nsg.*.id, count.index)
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
   
 }

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



resource "azurerm_virtual_machine" "vm" {
 count                 = var.countvalue 
 name                  = "AENet-Edocs-VM${count.index}"
 location              = azurerm_resource_group.resgrp.location 
 zones =[element(var.av_zone,count.index)]
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