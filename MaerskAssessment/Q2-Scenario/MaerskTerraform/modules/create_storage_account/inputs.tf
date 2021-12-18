
variable "resgrp"{
  description="Resource Group"
}

variable "location"{
  description="EastUs"
}

variable "storageaccname"{
  description="Storage Account Name"
}

variable "filesharename"{
  description="Fileshare name"
}

variable "tags" {
  type=map
  default={
    Env="Dev"
   
  }
}
