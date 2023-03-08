data "azurerm_subscription" "current" {}

data "grafana_folder" "topic" {
  count = var.grafana_enabled ? 1 : 0
  title = var.topic
}

data "azurerm_key_vault" "vault_toolbox" {
  name                  = "cloud-0e842b-kv-weu"
  resource_group_name   = "cloud-toolbox-rg-security-weu"
  provider              = azurerm.toolbox
}

data "azurerm_key_vault_secret" "chef_validation_key" {
  name                  = "schenker-chef-validation-key"
  key_vault_id          = data.azurerm_key_vault.vault_toolbox.id
  provider              = azurerm.toolbox
}

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

data "azurerm_resource_group" "topic_rg" {
  name                  = "${var.topic}-${var.stage}-rg-${module.map.region_map[var.location]}"
}

data "azurerm_application_security_group" "topic_asg" {
  name                  = "${var.topic}-${var.stage}-asg-${module.map.region_map[var.location]}"
  resource_group_name   = data.azurerm_resource_group.topic_rg.name
}

data "azurerm_key_vault_secret" "grafana_notification_uid" {
  count                 = var.grafana_enabled ? 1 : 0
  name                  = "notification-uid-${var.topic}"
  key_vault_id          = data.azurerm_key_vault.vault_grafana.id
}
