
resource "azurerm_resource_group" "resgrp" {
 name     = var.resgrp
 location = var.location
}

# resource "azurerm_virtual_network" "vnet" {
#  name                = var.vnet-name
#  address_space       = ["10.1.0.0/24"]
#  location            = azurerm_resource_group.resgrp.location
#  resource_group_name = azurerm_resource_group.resgrp.name
#  tags= var.tags
# }

# resource "azurerm_subnet" "subnet" {
#  name                 = var.subnet-name
#  resource_group_name  = azurerm_resource_group.resgrp.name
#  virtual_network_name = azurerm_virtual_network.vnet.name
#  address_prefix       = "10.1.0.0/24"
# }

resource "azurerm_public_ip" "elb-lb-pip" {
 name                         = var.lb-pip-name
 location                     = azurerm_resource_group.resgrp.location
 resource_group_name          = azurerm_resource_group.resgrp.name
 allocation_method            = "Static"
 sku                          ="Standard"
}
resource "azurerm_lb" "ELB" {
 name                = var.lb-name
 location            = azurerm_resource_group.resgrp.location
 resource_group_name = azurerm_resource_group.resgrp.name
 sku                 ="Standard"

 frontend_ip_configuration {
   name                 = "PublicIPAddress"
   subnet_id              =azurerm_subnet.subnet.id
   zones =var.av_zone
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

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "nsg-associate" {
  count               = "${length(keys(local.nsgrules))}" 
    network_interface_id      = azurerm_network_interface.nic.id
    network_security_group_id = element(azurerm_network_security_group.nsg.*.id, count.index)
}

resource "azurerm_network_interface" "nic" { 
 name                = "AE-Web-Nic"
 location            = azurerm_resource_group.resgrp.location
 resource_group_name = azurerm_resource_group.resgrp.name

 ip_configuration {
   name                          = var.nicipname
   subnet_id                     = azurerm_subnet.subnet.id
   private_ip_address_allocation = "dynamic"
   
   
 }
 
}

resource "azurerm_network_interface_backend_address_pool_association" "nic-associate" {
    network_interface_id      = azurerm_network_interface.nic.id
     ip_configuration_name   = var.nicipname
    backend_address_pool_id = azurerm_lb_backend_address_pool.backendpool-name.id
}

resource "azurerm_managed_disk" "vmmanageddisk" {
 
 name                 = "AE-Web-Datadisk"
 location             = azurerm_resource_group.resgrp.location
 resource_group_name  = azurerm_resource_group.resgrp.name
 storage_account_type = var.disk-storage-account-type
 create_option        = "Empty"
 disk_size_gb         = var.disk_size_gb 
}

resource "azurerm_virtual_machine" "vm" { 
 name                  = "AENet-Edocs-WebVM"
 location              = azurerm_resource_group.resgrp.location
 zones =var.av_zone
 resource_group_name   = azurerm_resource_group.resgrp.name
 network_interface_ids = azurerm_network_interface.nic.*.id
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
   name              = "AE-Web-OSdisk"
   caching           = "ReadWrite"
   create_option     = "FromImage"
   managed_disk_type = "Standard_LRS"
 }


 os_profile {
   computer_name  = var.computer_name
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

resource "azurerm_virtual_machine_extension" "iis" {
  name                 = "install-iis"
  virtual_machine_id = azurerm_virtual_machine.vm.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"

  settings = <<SETTINGS
    { 
      "commandToExecute": "powershell Add-WindowsFeature Web-Asp-Net45;Add-WindowsFeature NET-Framework-45-Core;Add-WindowsFeature Web-Net-Ext45;Add-WindowsFeature Web-ISAPI-Ext;Add-WindowsFeature Web-ISAPI-Filter;Add-WindowsFeature Web-Mgmt-Console;Add-WindowsFeature Web-Scripting-Tools;Add-WindowsFeature Search-Service;Add-WindowsFeature Web-Filtering;Add-WindowsFeature Web-Basic-Auth;Add-WindowsFeature Web-Windows-Auth;Add-WindowsFeature Web-Default-Doc;Add-WindowsFeature Web-Http-Errors;Add-WindowsFeature Web-Static-Content;"
    } 
SETTINGS
}