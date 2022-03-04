terraform {
  required_providers {
    azurerm = {
      version = "2.90.0"
      source = "hashicorp/azurerm"
   }
 }
}
provider "azurerm" {
  features {}
}
~         
