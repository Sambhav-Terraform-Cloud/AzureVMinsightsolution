resource "azurerm_monitor_scheduled_query_rules_alert" "memalert" {
  name                = "memalert"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  action {
    action_group           = [azurerm_monitor_action_group.ag.id]
  }
  data_source_id = azurerm_log_analytics_solution.vminsights.id
  description    = "Free Space Alert Details in Work Notes"
  enabled        = true
  # Count all requests with server error result code grouped into 5-minute bins
  query       = <<-QUERY
  
  let MinTime = ago(2m);
  InsightsMetrics
  | where TimeGenerated > MinTime
  | where Origin == "vm.azm.ms"
  | where Namespace == "Memory" and Name == "AvailableMB"
  | extend TotalMemory = toreal(todynamic(Tags)["vm.azm.ms/memorySizeMB"]) | extend AvailableMemoryPercentage = (toreal(Val) / TotalMemory) * 100.0
  | summarize AggregatedValue = avg(AvailableMemoryPercentage) by bin(TimeGenerated, 15m), Computer, _ResourceId
  | where AggregatedValue >= 50
  | project Computer, _ResourceId ,AggregatedValue

  QUERY
  severity    = 1
  frequency   = 5
  time_window = 5
  trigger {
    operator  = "GreaterThan"
    threshold = 90
  }
}
