
resource "azurerm_dns_zone" "dns" {
 name                = var.dns-name
 resource_group_name = var.resgrp
  tags= var.tags
}

resource "azurerm_dns_a_record" "projectmydomain" {
name                = var.a-name-record
zone_name           = azurerm_dns_zone.dns.name
resource_group_name = var.resgrp
ttl                 = var.ttl
records             = var.records
}

resource "azurerm_dns_cname_record" "aecname" {
  name                = var.c-name-record
  zone_name           = azurerm_dns_zone.dns.name
  resource_group_name = var.resgrp
  ttl                 = var.ttl
  record     = var.record
}
