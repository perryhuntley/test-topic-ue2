data "azurerm_subscription" "current" {}

data "azurerm_key_vault" "vault_grafana" {
  name                  = local.default_key_vault_name
  resource_group_name   = local.default_key_vault_resource_group_name
}

data "azurerm_key_vault_secret" "graf-url" {
  name                  = "grafanaurl"
  key_vault_id          = data.azurerm_key_vault.vault_grafana.id
}

data "azurerm_key_vault_secret" "graf-secret-azure" {
  name                  = "grafanakeyazure"
  key_vault_id          = data.azurerm_key_vault.vault_grafana.id
}
