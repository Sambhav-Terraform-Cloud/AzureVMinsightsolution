# Log analytics solution
resource "azurerm_log_analytics_solution" "vminsights" {
  solution_name         = "vminsights"
  resource_group_name             = data.azurerm_resource_group.rg.name
  location                        = data.azurerm_resource_group.rg.location
  workspace_resource_id = data.azurerm_log_analytics_workspace.law.id
  workspace_name        = data.azurerm_log_analytics_workspace.law.name
  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/VMInsights"
  }
}
