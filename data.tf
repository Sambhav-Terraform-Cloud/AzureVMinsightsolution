data "azurerm_resource_group" "rg" {
  name = "myrg1"
}

data "azurerm_log_analytics_workspace" "law" {
  name = "vmloganalytics"
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_virtual_machine" "windowsVM" {
  name = "mywindowsvm1"
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_virtual_machine" "linuxVM" {
  name = "mylinuxvm1"
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_logic_app_workflow" "existing_logicapp" {
 name = local.logicappname
 resource_group_name = data.azurerm_resource_group.rg.name
 depends_on = [
    azurerm_resource_group_template_deployment.logicappdeploy
  ]
}
