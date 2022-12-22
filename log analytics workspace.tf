# Import the subscription and resource groups
data "azurerm_subscription" "sub" {
}

resource "random_password" "windowsvm-password" {
  length           = 24
  special          = false
}




# Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "law" {
  name                      = "vmloganalytics"
  resource_group_name             = data.azurerm_resource_group.rg.name
  location                        = data.azurerm_resource_group.rg.location
  sku                       = "PerGB2018"
  retention_in_days         = 365
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

# Add logging and monitoring extensions. This extension is needed for other extensions
resource "azurerm_virtual_machine_extension" "azure-monitor-agent" {
  
  name                  = "AzureMonitorWindowsAgent"
  virtual_machine_id    = azurerm_windows_virtual_machine.myWindowsVm1.id
  publisher             = "Microsoft.Azure.Monitor"
  type                  = "AzureMonitorWindowsAgent"
  type_handler_version  =  "1.5"
  automatic_upgrade_enabled  = true
  auto_upgrade_minor_version = true
}

# Dependency agent
resource "azurerm_virtual_machine_extension" "daa-agent" {
  depends_on = [  azurerm_virtual_machine_extension.azure-monitor-agent  ]
  vname                       = "DependencyAgentWindows"
  virtual_machine_id         = azurerm_windows_virtual_machine.myWindowsVm1.id
  publisher                  = "Microsoft.Azure.Monitoring.DependencyAgent"
  type                       = "DependencyAgentWindows"
  type_handler_version       = "9.10"
  automatic_upgrade_enabled  = true
  auto_upgrade_minor_version = true
}