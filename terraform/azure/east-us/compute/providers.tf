provider "azurerm" {
  version =  "1.35.0"
}

module "basic" {
  source = "../globals"
}

module "network" {
  source = "../networking"
}