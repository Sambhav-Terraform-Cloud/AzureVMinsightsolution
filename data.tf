data "azurerm_resource_group" "rg" {
  name = "myrg"
}

data "azurerm_log_analytics_workspace" "law" {
  name = "vmloganalytics"
}

data "azurerm_windows_virtual_machine" "windowsVM" {
  name = "mywindowsvm1"
}

data "azurerm_linux_virtual_machine" "linuxVM" {
  name = "mylinuxvm1"
}
