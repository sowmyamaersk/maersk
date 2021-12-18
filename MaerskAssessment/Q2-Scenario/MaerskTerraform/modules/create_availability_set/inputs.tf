 variable "resgrp"{
  description="Resource Group"
}

variable "location"{
  description="Location"
}

variable "avset"{
  description="Avalability Set Name"
}
variable "fault-domain-count"{
  description="Count of fault domain"
}
variable "update-domain-count"{
  description="Count of upgrade domain"
}


variable "tags" {
  type=map
default={
        Env="Dev"
        
 }
}