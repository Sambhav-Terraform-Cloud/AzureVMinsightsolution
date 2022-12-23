
# Add logging and monitoring extensions. This extension is needed for other extensions
resource "azurerm_virtual_machine_extension" "azure-monitor-agent" {

  for_each = {
    "AzureMonitorWindowsAgent" = {machine_id = "azurerm_windows_virtual_machine.myWindowsVm1.id", version = "1.10.0.0"}
    "AzureMonitorLinuxAgent" = {machine_id = "azurerm_linux_virtual_machine.myLinuxVm1.id", version = "1.10.0.0"}
  }
  
  name                  = each.key
  virtual_machine_id    = each.value.machine_id
  publisher             = "Microsoft.Azure.Monitor"
  type                  = each.key
  type_handler_version  =  each.value.version
  automatic_upgrade_enabled  = true
  auto_upgrade_minor_version = true
}

# Dependency agent extension
resource "azurerm_virtual_machine_extension" "azure-dependency-agent" {

  depends_on = [  azurerm_virtual_machine_extension.azure-monitor-agent  ]
  
  #type as key
  for_each = {
    "DependencyAgentWindows" = {id = "azurerm_windows_virtual_machine.myWindowsVm1.id", version = "9.10"}
    "DependencyAgentLinux" = {id = "azurerm_linux_virtual_machine.myLinuxVm1.id", version = "9.5"}
  }
  
  name                  = "DAExtension"
  virtual_machine_id    = each.value.id
  publisher             = "Microsoft.Azure.Monitoring.DependencyAgent"
  type                  = each.key
  type_handler_version  =  "1.5"
  automatic_upgrade_enabled  = true
  auto_upgrade_minor_version = true
}
