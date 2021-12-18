/* Declare variables*/
provider "azurerm" {
  features{}
  subscription_id 	= var.subscription_id
  client_id 		    = var.client_id
  client_secret 	  = var.client_secret
  tenant_id 		    = var.tenant_id
}
variable "subscription_id" {
  description = "Subscription ID"
  default = ""
}
variable "client_id" {
  description = "Web App Id"
  default = ""
}
variable "client_secret" {
  description = "Key for Service principal"
  default = ""
}
variable "tenant_id" {
  description = "Tenant ID from AD"
  default = ""
}

