
  # Add logging and monitoring extensions. This extension is needed for other extensions

/*
resource "azurerm_virtual_machine_extension" "azure-monitor-agent" {
  
  depends_on                 = [azurerm_virtual_machine_extension.azureda]
  
  for_each = {
    "AzureMonitorWindowsAgent" = {machine_id = "${data.azurerm_virtual_machine.windowsVM.id}", version = "1.8"}
    "AzureMonitorLinuxAgent" = {machine_id = "${data.azurerm_virtual_machine.linuxVM.id}", version = "1.0"}
  }
  
  name                  = each.key
  publisher             = "Microsoft.Azure.Monitor"
  type                  = each.key
  type_handler_version  =  each.value.version
  automatic_upgrade_enabled  = true
  auto_upgrade_minor_version = "true"
  virtual_machine_id    = each.value.machine_id
  
  settings = jsonencode({
    workspaceId               = "${data.azurerm_log_analytics_workspace.law.id}"
    azureResourceId           = each.value.machine_id
    stopOnMultipleConnections = false

  })
  protected_settings = jsonencode({
    "workspaceKey" = "${data.azurerm_log_analytics_workspace.law.primary_shared_key}"
  })
}

*/
  
resource "azurerm_virtual_machine_extension" "azuremonitorwindowsagent" {
  depends_on                 = [azurerm_virtual_machine_extension.da]
  name                       = "AzureMonitorWindowsAgent"
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorWindowsAgent"
  type_handler_version       = 1.8
  automatic_upgrade_enabled  = true
  auto_upgrade_minor_version = "true"
  virtual_machine_id         = data.azurerm_virtual_machine.windowsVM.id
  settings = jsonencode({
    workspaceId               = data.azurerm_log_analytics_workspace.law.id
    azureResourceId           = data.azurerm_virtual_machine.windowsVM.id
    stopOnMultipleConnections = false
  })
  protected_settings = jsonencode({
    "workspaceKey" = data.azurerm_log_analytics_workspace.workspace.primary_shared_key
  })
}

resource "azurerm_virtual_machine_extension" "azuremonitorlinuxagent" {
  depends_on                 = [azurerm_virtual_machine_extension.da]
  name                       = "AzureMonitorLinuxAgent"
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorLinuxAgent"
  type_handler_version       = 1.0
  automatic_upgrade_enabled  = true
  auto_upgrade_minor_version = "true"
  virtual_machine_id         = data.azurerm_virtual_machine.linuxVM.id
  settings = jsonencode({
    workspaceId               = data.azurerm_log_analytics_workspace.law.id
    azureResourceId           = data.azurerm_virtual_machine.linuxVM.id
    stopOnMultipleConnections = false
  })
  protected_settings = jsonencode({
    "workspaceKey" = data.azurerm_log_analytics_workspace.law.primary_shared_key
  })
}

# Dependency agent extension
resource "azurerm_virtual_machine_extension" "azureda" {
  
  for_each = {
    "DependencyAgentWindows" = {machine_id = "${data.azurerm_virtual_machine.windowsVM.id}", version = "9.10"}
    "DependencyAgentLinux" = {machine_id = "${data.azurerm_virtual_machine.linuxVM.id}", version = "9.5"}
  }
  
  name                  = "DAExtension"
  virtual_machine_id    = each.value.machine_id
  publisher             = "Microsoft.Azure.Monitoring.DependencyAgent"
  type                  = each.key
  type_handler_version  =  each.value.version
  automatic_upgrade_enabled  = true
  auto_upgrade_minor_version = true
}
