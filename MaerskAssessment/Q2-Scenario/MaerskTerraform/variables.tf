variable "resource_group_name"{
  description="Resource Group"
  # default="resgrpname"
}

variable "location"{
  description="EastUs"
  # default="EastUS"
}

variable "avsetname"{
  description="Avalability Set Name"
  #default="Avalability-Set"
}
variable "fault_domain"{
  description="Count of fault domain"
  #default="2"
}
variable "update_domain"{
  description="Count of upgrade domain"
  #default="3"
}


variable "dns_name"{
  description="DNS Name"
 # default="adb.Mrsknetworks.com"
}
variable "A_record"{
  description="A name domain record"
 # default="Mrsk"
}  

variable "c_name_record"{
  description="C name record"
 # default="Mrsk"
} 
 
variable "record"{
  description="C name domain record"
}  

variable "ttl"{
  description="value of time to live"
  #default="300"
}

variable "records"{
  description="records"
  #default=["127.0.0.1"]
}

variable "ELB_name"{
  description="Load Balancer Name"
  #default="LB-Name"
}

variable "ELB_pip_name"{
  description="Load Balancer PIP Name"
 # default="LB-PIP-Name"
}

variable "ELB_pip_id"{
  description="Load Balancer PIP ID"
 # default="LB-PIP-ID"
}
variable "lb_frontend_ip_configuration_name"{
  description="Load Balancer front end configuration IP name"
 # default="Mrsk-FrontEnd-IP-Name"
}

variable "backendpool_name"{
  description="Backend pool name"
 # default="backendpool-name"
}
variable "nsg_name"{
  description="Network Security Group"
  # default="NSG "
}
variable "sql_servername"{
  description="SQL Server Name"
 # default="Mrskdev"
  #tags=var.tags
}
variable "sql_dbname"{
  description="SQL Database Name"
  #default="DEV_Mrsk_admin"
}  
variable "sql_serverversion"{
  description="SQL server version"
  #default="12.0"
} 
variable "sql_serverusername"{
  description="SQL server Login name"
  #default="4dm1n157r470r"
} 
variable "sql_serverpassword"{
  description="SQL server password"
 # default="4-v3ry-53cr37-p455w0rd"
} 
variable "storageaccname"{
  description="Storage Account Name"
 # default="Mrskstorageacc"
}
variable "filesharename"{
  description="Fileshare name"
  #default="Mrskfileshare"
}

variable "vnet_name"{
  description="Virtual Network Name"
  #default="Mrsk_Docs_RG-vnet"
}

variable "vnet_address_space"{
  description="Virtual Network address space"
  
}

variable "subnet_name"{
  description="Subnet Name"
  #default="default"
}

variable "subnet_address_prefix"{
  description="Virtual Network address space"
  #default="Mrsk_Docs_RG-vnet"
}


variable "tags" {
  type=map
default={
        Env="Dev"
        Dept="IT"
 }
}

