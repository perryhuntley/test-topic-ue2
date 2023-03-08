module "map" {
  source                                    = "git@git.signintra.com:dct/azure/terraform-subscription-static.git"
}

module "common_resources" {
    source                                  = "git@git.signintra.com:dct/azure/terraform-azurerm-common-resources.git"
    topic                                   = var.topic                                                     # Required - Topic Name
    stage                                   = var.stage                                                     # Required - Stage Name
    heritage                                = var.heritage                                                  # Required - Heritage (GIT Repo - HTTPS URL)
    contact                                 = var.contact                                                   # Required - Contact Email ID of Topic Owner
    costcenter                              = var.costcenter                                                # Required - Cost Center
    executionitem                           = var.executionitem                                             # Required - Execution Item
    operatedby                              = var.operatedby                                                # Required - Operated by (GPO or IMO)
    custom_tags                             = var.custom_tags                                               # Optional - A Map of Custom Tags, if any
    network_type                            = var.network_type                                              # Required - Network Type; 'hub'/'spoke'
    location                                = var.location                                                  # Required - Target Location
    grafana_enabled                         = var.grafana_enabled                                           # Optional - Flag to enable Grafana Dashboard for the VM. Defaults to false
    key_vault_id                            = data.azurerm_key_vault.vault_grafana.id                       # Required - Resource ID of the Key Vault where Notifications UID will be stored as a secret
}
