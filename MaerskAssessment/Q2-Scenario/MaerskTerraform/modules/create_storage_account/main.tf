
resource "azurerm_storage_account" "storageaccn" {
  name                     = var.storageaccname
  resource_group_name      = var.resgrp
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_share" "fileshare" {
  name                 = var.filesharename
  storage_account_name = azurerm_storage_account.storageaccn.name
  quota                = 50
}