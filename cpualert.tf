
resource "azurerm_monitor_metric_alert" "cpualert" {
  name                = "cpu-alertrule-${data.azurerm_resource_group.rg.name}"
  resource_group_name = data.azurerm_resource_group.rg.name
  scopes              = [var.scope]
  description         = "Higher Thresold"
  target_resource_type = "Microsoft.Compute/virtualMachines"
  target_resource_location = var.location
  frequency                 = var.frequency
  window_size               = var.window_size
  severity                  = var.severity
  
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
