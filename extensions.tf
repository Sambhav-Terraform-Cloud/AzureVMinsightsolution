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
  
  settings = <<SETTINGS
    {
        "workspaceId": "${data.azurerm_log_analytics_workspace.law.workspace_id}",
        "azureResourceId": "${each.value.machine_id}",
        "stopOnMultipleConnections": "false"
    }
  SETTINGS
  protected_settings = <<PROTECTED_SETTINGS
    {
      "workspaceKey": "${data.azurerm_log_analytics_workspace.law.primary_shared_key}"
    }
  PROTECTED_SETTINGS
}

  
# OMS Agent for Linux
resource "azurerm_virtual_machine_extension" "OMS" {
  //depends_on = [  azurerm_virtual_machine_extension.azureda  ]
  name                       = "OMSExtension"
  virtual_machine_id         =  data.azurerm_virtual_machine.linuxVM.id
  publisher                  = "Microsoft.EnterpriseCloud.Monitoring"
  type                       = "OmsAgentForLinux"
  type_handler_version       = "1.13"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
    {
      "workspaceId" : "${data.azurerm_log_analytics_workspace.law.workspace_id}"
    }
  SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
    {
      "workspaceKey" : "${data.azurerm_log_analytics_workspace.law.primary_shared_key}"
    }
  PROTECTED_SETTINGS
}


# MMA Agent for windows
resource "azurerm_virtual_machine_extension" "msmonitor-agent-winodws" {
  //depends_on = [  azurerm_virtual_machine_extension.azureda  ]
  name                  = "MicrosoftMonitoringAgent"  # Must be called this
  virtual_machine_id    = data.azurerm_virtual_machine.windowsVM.id
  publisher             = "Microsoft.EnterpriseCloud.Monitoring"
  type                  = "MicrosoftMonitoringAgent"
  type_handler_version  =  "1.0"
  # Not yet supported
  # automatic_upgrade_enabled  = true
  # auto_upgrade_minor_version = true
  settings = <<SETTINGS
    {
        "workspaceId": "${data.azurerm_log_analytics_workspace.law.workspace_id}",
        "azureResourceId": "${data.azurerm_virtual_machine.windowsVM.id}",
        "stopOnMultipleConnections": "false"
    }
  SETTINGS
  protected_settings = <<PROTECTED_SETTINGS
    {
      "workspaceKey": "${data.azurerm_log_analytics_workspace.law.primary_shared_key}"
    }
  PROTECTED_SETTINGS
}

*/
  
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
