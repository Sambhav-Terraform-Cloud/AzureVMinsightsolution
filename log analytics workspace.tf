# Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "law" {
  name                      = "vmloganalytics"
  resource_group_name             = data.azurerm_resource_group.rg.name
  location                        = data.azurerm_resource_group.rg.location
  sku                       = "Standard"
  retention_in_days         = 30
  internet_ingestion_enabled= true
  internet_query_enabled    = false
}

# Log analytics solution
resource "azurerm_log_analytics_solution" "vminsights" {
  solution_name         = "vminsights"
  resource_group_name             = data.azurerm_resource_group.rg.name
  location                        = data.azurerm_resource_group.rg.location
  workspace_resource_id = azurerm_log_analytics_workspace.law.id
  workspace_name        = azurerm_log_analytics_workspace.law.name
  plan {
    publisher = "Microsoft"
    product   = "VMInsights"
  }
}
