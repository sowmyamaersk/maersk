
variable "resgrp"{
  description="Resource Group"
}

variable "location"{
  description="Location"
}

variable "lb-name"{
  description="Load Balancer Name"
}

variable "lb-pip-name"{
  description="Load Balancer PIP Name"
}

variable "lb_frontend_ip_configuration_name"{
  description="Load Balancer front end configuration IP name"
}

variable "backendpool-name"{
  description="Backend pool name"
}

locals {
  lbrules = {
    RDPRule = {
   name                           = "RDPRule"
   protocol                       = "TCP"
   frontend_port                  = "3389"
   backend_port                   = "3389"      
    }

  HTTPRule = {
   name                        = "HTTPRule"
   protocol                       = "TCP"
   frontend_port                  = "80"
   backend_port                   = "80"
    }    
  }
}

locals {
  lbprobe = {
    HTTPProbe = {
      name                           = "HTTPProbe"
      protocol                       = "TCP"
      port                           ="80"
      interval_in_seconds            ="15"
      number_of_probes               = "2"
        
    }
  HTTPSProbe = {
      name                           = "HTTPSProbe"
      protocol                       = "TCP"
      port                           ="443"
      interval_in_seconds            ="15"
      number_of_probes               = "2"
    }    
  }
}
locals {
  lbnatrules = {
    RDPNATRule = {
   name                         = "RDPNATRule"
   protocol                       = "UDP"
   frontend_port                  = "3389"
   backend_port                   = "3389"         
    }
  }
}


variable "tags" {
  type=map
  default={
    Env="Dev"
    
  }
}
