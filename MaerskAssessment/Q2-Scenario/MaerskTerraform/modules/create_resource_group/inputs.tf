
variable "resgrp"{
  description="Resource Group"
}

variable "location"{
  description="EastUs"
}


variable "tags" {
  type=map
default={
        Env="Dev"
       
 }
}
