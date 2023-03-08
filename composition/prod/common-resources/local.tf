locals {
  ###Subscription Related Parameters
  subscription_id_full                  = data.azurerm_subscription.current.id
  subscription_hash                     = substr(lower(md5(lower(replace(data.azurerm_subscription.current.display_name, "-", "")))), 0, 6)
  subscription_name_short               = lower(replace(data.azurerm_subscription.current.display_name, "-", ""))

  ###General Parameters
  cloud_prefix                          = "cloud-${local.subscription_name_short}"
  location_code                         = module.map.region_map[var.location]
  
  ###Default Azure Resources Reference Related
  default_key_vault_resource_group_name = "${local.cloud_prefix}-rg-security-${local.location_code}"
  default_key_vault_name                = var.network_type == "hub" ? local.location_code == "aue" ? "cloud-${local.subscription_hash}b-kv-${local.location_code}" : "cloud-${local.subscription_hash}-kv-${local.location_code}" : "cloud-${local.subscription_hash}-kv-${local.location_code}"
}