variable "resgrp"{
  description="Resource Group"
}

variable "location"{
  description="Location"
}

variable "nsg"{
  description="Network Security Group"
}

locals {
  nsgrules = {
   

  HTTPRule = {
        name                       = "HTTP"
        priority                   = 100
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
        priority                   = 101
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

variable "tags" {
  type=map
  default={
    Env="Dev"
    
  }
}
