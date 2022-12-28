 resource "azurerm_monitor_data_collection_rule" "mydcr" {
      name                = "My-dcr"
      resource_group_name = var.az_resource_group_name
      location            = var.az_location
    
      destinations {
        log_analytics {
          workspace_resource_id = azurerm_log_analytics_workspace.law.id
          name                  = "log-destination"
        }
    
        azure_monitor_metrics {
          name = "log-metrics"
        }
      } 
    
      data_flow {
        streams      = ["Microsoft-InsightsMetrics"]
        destinations = ["log-destination"]
      }
    
      data_sources {
    
        performance_counter {
          streams                       = ["Microsoft-InsightsMetrics"]
          sampling_frequency_in_seconds = 60
          counter_specifiers            = ["\\VmInsights\\DetailedMetrics"]
          name                          = "VMInsightsPerfCounters"
        }
    }
     }
    
    # associate to a Data Collection Rule
    resource "azurerm_monitor_data_collection_rule_association" "mydcra" {
      
    for_each = {
        "windowsVM-dcra-" = {machine_id = "${azurerm_windows_virtual_machine.myWindowsVm1.id}", desc = "Windows VM data collection rule association"}
        "linuxVM-dcra" = {machine_id = "${azurerm_linux_virtual_machine.myLinuxVm1.id}", desc = "Linux VM data collection rule association"}
    }
      name                    = each.key
      target_resource_id      = each.value.machine_id
      data_collection_rule_id = azurerm_monitor_data_collection_rule.example.id
      description             = each.value.desc
    }
