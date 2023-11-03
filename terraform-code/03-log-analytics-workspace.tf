resource "azurerm_log_analytics_workspace" "insights" {
  name                = "${var.environment}-log-${random_pet.aksrandom.id}"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  sku                 = "PerGB2018" # Free, PerNode, Premium, Standard, Standalone, Unlimited, PerGB2018 # Default PerGB2018
  # Free, Premium, Standard, Unlimited is not working
  retention_in_days = 30
}
