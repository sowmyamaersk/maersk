
variable "resgrp"{
  description="Resource Group"
  default="AE_EDocs_RG"
}

variable "location"{
  description="EastUs"
  default="EastUS"
}

variable "countvalue" {
  description="Value of the count"
  default = "1"
}

variable "av_zone" {
  description="Availability Zone"
  default = [3]
}


variable "lb-name"{
  description="Load Balancer Name"
  default="AE-LB-Name"
}

variable "lb-pip-name"{
  description="Load Balancer PIP Name"
  default="AE-LB-PIP-Name"
}

variable "lb-pip-id"{
  description="Load Balancer PIP ID"
  default="AE-LB-PIP-ID"
}
variable "backendpool-name"{
  description="Backend pool name"
  default="AE-Backendpool-Name"
}
variable "nsg"{
  description="Network Security Group"
  default="AE-NSG"
}
locals {
  nsgrules = {
    RDPRule = {
        name                       = "RDP"
        priority                   = 101
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "3389"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

  HTTPRule = {
        name                       = "HTTP"
        priority                   = 102
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    } 
  HTTPSRule = {
        name                       = "HTTPS"
        priority                   = 103
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    } 	
  }
}
variable "nicipname"{
  description="AE NIC"
  default="edocsnicip"
}
variable "disk-storage-account-type"{
  description="disk-storage-account-type"
  default="Standard_LRS"
}
variable "disk-create_option"{
  description="disk-create_option"
  default="Empty"
}
variable "disk_size_gb"{
  description="disk_size_gb"
  default="1023"
}



variable "vm_size"{
  description="VM Size"
  default="Standard_DS1_v2"
}
variable "vnet-name"{
  description="Virtual Network Name"
  default="AE_Docs_RG-vnet"
}
variable "subnet-name"{
  description="Subnet Name"
  default="default"
}


variable "vm_image_publisher" {
// Get-AzureRmVMImagePublisher -Location 'uksouth' | Select PublisherName
description = "vm image vendor"
default = "MicrosoftWindowsServer"
}
variable "vm_image_offer" {
//Get-AzureRMVMImageOffer -Location 'uksouth' -Publisher 'MicrosoftWindowsServer' | Select Offer
description = "vm image vendor's VM offering"
default = "WindowsServer"
}
variable "vm_image_sku" {
default = "2016-Datacenter"
}
variable "vm_image_version" {
description = "vm image version"
default = "latest"
}

variable "computer_name" {
description = "Computer Name"
default = "EdocsHostname"
}
variable "VM_ADMIN" {
description = "Admin Name"
default = "VMAdmin"
}
variable "VM_PASSWORD" {
description = "password"
default = "Password@123"
}
variable "tags" { 
   
  default={
   ApplicationID="TST"
    Environment="TST"
    Name="VMImage-Test"
  }
  }
