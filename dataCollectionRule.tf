# Data Collection Rules

# Data colletion rule - Windows
resource "azurerm_monitor_data_collection_rule" "rule-windows" {
  name                = "my-dcr-windows"

  destinations {
    log_analytics {
      workspace_resource_id = azurerm_log_analytics_workspace.law.id
      name                  = "destination-log-windows"
    }

    azure_monitor_metrics {
      name = "destination-metrics-windows"
    }
  }

  data_flow {
    streams      = ["Microsoft-InsightsMetrics"]
    destinations = ["destination-metrics-windows"]
  }

  data_flow {
    streams      = ["Microsoft-InsightsMetrics", "Microsoft-Syslog", "Microsoft-Perf", "Microsoft-WindowsEvent"]
    destinations = ["destination-log-windows"]
  }

  data_sources {
    performance_counter {
      streams                       = ["Microsoft-Perf", "Microsoft-InsightsMetrics"]
      sampling_frequency_in_seconds = 60
      counter_specifiers            = ["\\VmInsights\\DetailedMetrics"]
      name                          = "Win-VMInsightsPerfCounters"
    }

  }
  depends_on = [
    azurerm_log_analytics_solution.vminsights
  ]
}


# Data colletion rule - Linux

resource "azurerm_monitor_data_collection_rule" "rule-linux" {
  name                = "my-dcr-linux"

  destinations {
    log_analytics {
      workspace_resource_id = azurerm_log_analytics_workspace.law.id
      name                  = "destination-log-linux"
    }

    azure_monitor_metrics {
      name = "destination-metrics-linux"
    }
  }

  data_flow {
    streams      = ["Microsoft-InsightsMetrics"]
    destinations = ["destination-metrics-linux"]
  }

  data_flow {
    streams      = ["Microsoft-InsightsMetrics", "Microsoft-Syslog", "Microsoft-Perf"]
    destinations = ["destination-log-linux"]
  }

  data_sources {
    performance_counter {
      streams                       = ["Microsoft-Perf", "Microsoft-InsightsMetrics"]
      sampling_frequency_in_seconds = 60
      counter_specifiers            = ["\\VmInsights\\DetailedMetrics"]
      name                          = "Win-VMInsightsPerfCounters"
    }

  }
  depends_on = [
    azurerm_log_analytics_solution.vminsights
  ]
}

resource "azurerm_monitor_data_collection_rule_association" "dcra" {
  
  for_each = {
        "windowsVM-dcra-" = {machine_id = "${azurerm_windows_virtual_machine.myWindowsVm1.id}", desc = "Windows VM data collection rule association", dcra_id = "${azurerm_monitor_data_collection_rule.rule-windows.id}"}
        "linuxVM-dcra" = {machine_id = "${azurerm_linux_virtual_machine.myLinuxVm1.id}", desc = "Linux VM data collection rule association", dcra_id = "${azurerm_monitor_data_collection_rule.rule-linux.id}"}
  }
  name                    = each.key
  target_resource_id      = each.value.machine_id
  data_collection_rule_id = each.value.dcra_id
  description             = each.value.desc
}
