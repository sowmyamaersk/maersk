 module "create-res-grp" {
    source      = "./modules/create_resource_group"
    resgrp    = "${var.resource_group_name}"
    location  = "${var.location}"
   
}

 module "create-avset" {
     source      = "./modules/create_availability_set"
     resgrp=      "${module.create-res-grp.name}"
     location    = "${var.location}"
     avset       ="${var.avsetname}"
     fault-domain-count="${var.fault_domain}"
     update-domain-count="${var.update_domain}"
     
}
module "create-dns" {
    source      = "./modules/create_dns"   
    resgrp=      "${module.create-res-grp.name}"
    location    = "${var.location}"
    dns-name    ="${var.dns_name}"
    a-name-record="${var.A_record}"
    c-name-record="${var.c_name_record}"
    ttl          ="${var.ttl}"
    records      ="${var.records}"
    record       ="${var.record}"
}

module "create-external-lb" {
    source      = "./modules/create_external_lb"
    resgrp=      "${module.create-res-grp.name}"
    location    = "${var.location}"
    lb-name     ="${var.ELB_name}"
    lb-pip-name ="${var.ELB_pip_name}"
   // lb-pip-id   ="${var.ELB_pip_id}"
    backendpool-name      ="${var.backendpool_name}"
    lb_frontend_ip_configuration_name="${var.lb_frontend_ip_configuration_name}"
}
module "create-nsg" {
    source      = "./modules/create_network_security_group"
    resgrp=      "${module.create-res-grp.name}"
    location    = "${var.location}"
    nsg         = "${var.nsg_name}"
}
module "create-storage-account" {
    source      = "./modules/create_storage_account"
    resgrp=      "${module.create-res-grp.name}"  
    location    = "${var.location}"
    storageaccname="${var.storageaccname}"
    filesharename="${var.filesharename}" 
}


module "create-vnet" {
 source      = "./modules/create_virtual_network"
     resgrp=      "${module.create-res-grp.name}"  
    location    = "${var.location}"    
    vnet-name   ="${var.vnet_name}"
    subnet-name ="${var.subnet_name}"
    vnet-address-space="${var.vnet_address_space}"
    subnet-address-prefix="${var.subnet_address_prefix}"
}

module "create-vm" {
    source      = "./modules/create_vm"
    countvalue       ="${var.countvalue}"
    resgrp=      "${module.create-res-grp.name}"  
    location    = "${var.rglocation}" 
    avset       ="${module.create-avset.name}"
    lb-name     ="${module.create-external-lb.lb-name}"
    lb-pip-id   ="${module.create-external-lb.lb-pip-id}"
    lb-pip-name ="${module.create-external-lb.lb-pip-name}"
    backendpool-name="${module.create-external-lb.backendpool-name}" 
    nsg         ="${module.create-nsg.nsg}"
   // nicname     ="${module.create-vnet.nicname}"
    nicipname ="${module.create-vnet.nicipname}"
    nicid     ="${module.create-vnet.nicid}"
    vnet-name  ="${module.create-vnet.vnet-name}"
    subnet-name="${module.create-vnet.subnet-name}"
    vmpip      ="${module.create-vnet.vmpip}"
    vm_image_offer="${var.vm_image_offer}" 
    vm_image_sku ="${var.vm_image_sku}" 
    vm_image_version="${var.vm_image_version}" 
    VM_ADMIN = "${var.VM_ADMIN}" 
    VM_PASSWORD="${var.VM_PASSWORD}" 
    vm_image_publisher="${var.vm_image_publisher}"
    computer_name="${var.computer_name}"
    vm_size="${var.vm_size}"    
    disk-storage-account-type="${var.disk-storage-account-type}"
    disk-create_option="${var.disk-create_option}"
    disk_size_gb="${var.disk_size_gb}"
}

