
  # Add logging and monitoring extensions. This extension is needed for other extensions
resource "azurerm_virtual_machine_extension" "azure-monitor-agent" {
  
  depends_on                 = [azurerm_virtual_machine_extension.azure-dependency-agent]
  
  for_each = {
    "AzureMonitorWindowsAgent" = {machine_id = "${azurerm_windows_virtual_machine.myWindowsVm1.id}", version = "1.10"}
    "AzureMonitorLinuxAgent" = {machine_id = "${azurerm_linux_virtual_machine.myLinuxVm1.id}", version = "1.24"}
  }
  
  name                  = each.key
  publisher             = "Microsoft.Azure.Monitor"
  type                  = each.key
  type_handler_version  =  each.value.version
  automatic_upgrade_enabled  = true
  auto_upgrade_minor_version = "true"
  virtual_machine_id    = each.value.machine_id
  
  settings = jsonencode({
    workspaceId               = azurerm_log_analytics_workspace.law.id
    azureResourceId           = each.value.machine_id
    stopOnMultipleConnections = false

  })
  protected_settings = jsonencode({
    "workspaceKey" = azurerm_log_analytics_workspace.law.primary_shared_key
  })
}


# Dependency agent extension
resource "azurerm_virtual_machine_extension" "azure-dependency-agent" {
  
  for_each = {
    "DependencyAgentWindows" = {machine_id = "${azurerm_windows_virtual_machine.myWindowsVm1.id}", version = "9.10"}
    "DependencyAgentLinux" = {machine_id = "${azurerm_linux_virtual_machine.myLinuxVm1.id}", version = "9.5"}
  }
  
  name                  = "DAExtension"
  virtual_machine_id    = each.value.machine_id
  publisher             = "Microsoft.Azure.Monitoring.DependencyAgent"
  type                  = each.key
  type_handler_version  =  each.value.version
  automatic_upgrade_enabled  = true
  auto_upgrade_minor_version = true
}
