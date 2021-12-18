
variable "resgrp"{
  description="Resource Group"
}

variable "location"{
  description="EastUs"
}

variable "vnet-name"{
  description="Virtual Network Name"
}
variable "vnet-address-space"{
  description="Virtual Network address space"
}

variable "subnet-name"{
  description="Subnet Name"
}

variable "subnet-address-prefix"{
  description="Virtual Network address space"
}

variable "tags" { 
   
  default={  
    Environment="Dev"    
  }
  }
