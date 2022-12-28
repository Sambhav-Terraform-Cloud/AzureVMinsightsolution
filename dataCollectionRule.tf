# Data Collection Rules
resource "azurerm_monitor_data_collection_rule" "rule" {
  name                = "my-dcr"
  resource_group_name             = data.azurerm_resource_group.rg.name
  location                        = data.azurerm_resource_group.rg.location

  destinations {
    log_analytics {
      workspace_resource_id = azurerm_log_analytics_workspace.law.id
      name                  = "destination-log"
    }

    azure_monitor_metrics {
      name = "destination-metrics"
    }
  }

  data_flow {
    streams      = ["Microsoft-InsightsMetrics"]
    destinations = ["destination-metrics"]
  }

  data_flow {
    streams      = ["Microsoft-InsightsMetrics", "Microsoft-Syslog", "Microsoft-Perf", "Microsoft-WindowsEvent"]
    destinations = ["destination-log"]
  }

  data_sources {
    performance_counter {
      streams                       = ["Microsoft-Perf", "Microsoft-InsightsMetrics"]
      sampling_frequency_in_seconds = 60
      counter_specifiers            = ["\\VmInsights\\DetailedMetrics"]
      name                          = "VMInsightsPerfCounters"
    }

  }
  depends_on = [
    azurerm_log_analytics_solution.vminsights
  ]
}


resource "azurerm_monitor_data_collection_rule_association" "dcra" {
  
  for_each = {
        "windowsVM-dcra-" = {machine_id = "${azurerm_windows_virtual_machine.myWindowsVm1.id}", desc = "Windows VM data collection rule association"}
        "linuxVM-dcra" = {machine_id = "${azurerm_linux_virtual_machine.myLinuxVm1.id}", desc = "Linux VM data collection rule association"}
  }
  name                    = each.key
  target_resource_id      = each.value.machine_id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.rule.id
  description             = each.value.desc
}
