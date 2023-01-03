

  # Add logging and monitoring extensions. This extension is needed for other extensions
resource "azurerm_virtual_machine_extension" "azure-monitor-agent" {
  
  timeouts {
    create = "20m"
    delete = "20m"
    update = "20m"
  }

  for_each = {
    "AzureMonitorWindowsAgent" = {machine_id = "${azurerm_windows_virtual_machine.myWindowsVm1.id}", version = "1.10"}
    "AzureMonitorLinuxAgent" = {machine_id = "${azurerm_linux_virtual_machine.myLinuxVm1.id}", version = "1.24"}
  }
  
  name                  = each.key
  virtual_machine_id    = each.value.machine_id
  publisher             = "Microsoft.Azure.Monitor"
  type                  = each.key
  type_handler_version  =  each.value.version
  automatic_upgrade_enabled  = true
  auto_upgrade_minor_version = true
  
  settings = jsonencode({
    workspaceId               = azurerm_log_analytics_workspace.law.workspace_id
    azureResourceId           = each.value.machine_id
    stopOnMultipleConnections = false

    authentication = {
      managedIdentity = {
        identifier-name  = "mi_res_id"
        identifier-value = azurerm_user_assigned_identity.myUserassignedIdentity.id
      }
    }

  })
  protected_settings = jsonencode({
    "workspaceKey" = azurerm_log_analytics_workspace.law.primary_shared_key
  })
}


# Dependency agent extension
resource "azurerm_virtual_machine_extension" "azure-dependency-agent" {

  // depends_on = [  azurerm_virtual_machine_extension.azure-monitor-agent  ]
  
  #type as key
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
