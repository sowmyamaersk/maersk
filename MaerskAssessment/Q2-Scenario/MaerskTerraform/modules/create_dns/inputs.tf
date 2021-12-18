
variable "resgrp"{
  description="Resource Group"
}

variable "location"{
  description="Location"
}

variable "dns-name"{
  description="DNS Name"
}
variable "a-name-record"{
  description="A name domain record"
}  

variable "c-name-record"{
  description="C name domain record"
}  

variable "ttl"{
  description="value of time to live"
}

variable "records"{
  description="records"
}

variable "record"{
  description="record "
}


variable "tags" { 
   
  default={
   
    Environment="Dev"
  
  }
  }
