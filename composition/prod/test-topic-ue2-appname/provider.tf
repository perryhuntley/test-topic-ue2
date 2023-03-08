terraform {
  backend "azurerm" {}
}

provider "azurerm" {
  version         = ">=2.0"
  subscription_id = module.map.full.gis_prod_ue2
  features {}
}

provider "azurerm" {
  alias   = "toolbox"
  subscription_id = "498f05c7-7aa5-4fd5-8e86-afe42d55808a"
  features {}
}

provider "grafana" {
  url                   = data.azurerm_key_vault_secret.graf-url.value
  auth                  = data.azurerm_key_vault_secret.graf-secret-azure.value
  org_id                = 4
}


