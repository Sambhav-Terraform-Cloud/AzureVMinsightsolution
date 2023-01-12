
resource "azurerm_monitor_metric_alert" "cpualert" {
  name                = "cpu-alertrule-${data.azurerm_resource_group.rg.name}"
  resource_group_name = data.azurerm_resource_group.rg.name
  scopes              = data.azurerm_subscription.current.id
  description         = "Higher Thresold"
  target_resource_type = "Microsoft.Compute/virtualMachines"
  target_resource_location = data.azurerm_resource_group.rg.location
  frequency                 = "PT1M"
  window_size               = "PT5M"
  severity                  = 1
  
  criteria { 
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Percentage CPU"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = var.cpuThresoldPercent
  }

  
  action {
    action_group_id = azurerm_monitor_action_group.ag.id
  }
}
