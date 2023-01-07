

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "example" {
  name                = "example-msqrv2"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.name.location

  evaluation_frequency = "PT10M"
  window_duration      = "PT10M"
  scopes               = [azurerm_log_analytics_solution.vminsights.id]
  severity             = 4
  criteria {
    query                   = <<-QUERY
      InsightsMetrics\n| where Origin == \"vm.azm.ms\"\n| where Namespace == \"Memory\" and Name == \"AvailableMB\"\n| extend TotalMemory = toreal(todynamic(Tags)[\"vm.azm.ms/memorySizeMB\"]) | extend AvailableMemoryPercentage = (toreal(Val) / TotalMemory) * 100.0\n| summarize AggregatedValue = avg(AvailableMemoryPercentage) by bin(TimeGenerated, 15m), Computer, _ResourceId\n| project Computer, _ResourceId ,AggregatedValue\n
      QUERY
    time_aggregation_method = "Maximum"
    threshold               = 75
    operator                = "LessThan"

    //resource_id_column    = "client_CountryOrRegion"
    metric_measure_column = "AggregatedValue"
    dimension {
      name     = "client_CountryOrRegion"
      operator = "Exclude"
      values   = ["123"]
    }

     dimension {
                                    name = "Computer"
                                    operator = "Include"
                                    values = ["*"]
                                }
    failing_periods {
      minimum_failing_periods_to_trigger_alert = 1
      number_of_evaluation_periods             = 1
    }
  }

  auto_mitigation_enabled          = true
  workspace_alerts_storage_enabled = false
  description                      = "High Memory Alert - Details in Worknotes"
  display_name                     = "Memory-alert"
  enabled                          = true
  query_time_range_override        = "PT1H"
  skip_query_validation            = true
  action {
    action_groups = [azurerm_monitor_action_group.ag.id]
  }
}


/*
  resource "azurerm_resource_group_template_deployment" "memory_alert_deploy" {
  name                 =    "deployment-${data.azurerm_resource_group.rg.name}-memalert"
  resource_group_name  =     data.azurerm_resource_group.rg.name
  deployment_mode      =     "Incremental"
  parameters_content = jsonencode({
    "location" = { value = data.azurerm_resource_group.rg.location }
  })
  template_content  =     <<TEMPLATE
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "scheduledqueryrules_Memalert_name": {
            "defaultValue": "Memalert",
            "type": "String"
        },
        "actionGroups_actiongroup_logicapp_myrg1_externalid": {
            "defaultValue": "/subscriptions/913501B7-19FA-468C-8F19-29F69DCADE21/resourceGroups/myrg1/providers/microsoft.insights/actionGroups/actiongroup-logicapp-myrg1",
            "type": "String"
        },
      "location": {
            "defaultValue": "westeurope"
            "type" : "String"
      }
    },
    "variables": {},
    "resources": [
        {
            "type": "microsoft.insights/scheduledqueryrules",
            "apiVersion": "2022-06-15",
            "name": "[parameters('scheduledqueryrules_Memalert_name')]",
            "location": "[parameters('location')]",
            "properties": {
                "displayName": "[parameters('scheduledqueryrules_Memalert_name')]",
                "severity": 1,
                "enabled": true,
                "evaluationFrequency": "PT5M",
                "scopes": [
                    "/subscriptions/913501b7-19fa-468c-8f19-29f69dcade21"
                ],
                "targetResourceTypes": [],
                "windowSize": "PT5M",
                "criteria": {
                    "allOf": [
                        {
                            "query": "InsightsMetrics\n| where Origin == \"vm.azm.ms\"\n| where Namespace == \"Memory\" and Name == \"AvailableMB\"\n| extend TotalMemory = toreal(todynamic(Tags)[\"vm.azm.ms/memorySizeMB\"]) | extend AvailableMemoryPercentage = (toreal(Val) / TotalMemory) * 100.0\n| summarize AggregatedValue = avg(AvailableMemoryPercentage) by bin(TimeGenerated, 15m), Computer, _ResourceId\n| project Computer, _ResourceId ,AggregatedValue\n",
                            "timeAggregation": "Total",
                            "metricMeasureColumn": "AggregatedValue",
                            "dimensions": [
                                {
                                    "name": "Computer",
                                    "operator": "Include",
                                    "values": [
                                        "*"
                                    ]
                                }
                            ],
                            "resourceIdColumn": "_ResourceId",
                            "operator": "GreaterThan",
                            "threshold": 90,
                            "failingPeriods": {
                                "numberOfEvaluationPeriods": 1,
                                "minFailingPeriodsToAlert": 1
                            }
                        }
                    ]
                },
                "autoMitigate": false,
                "actions": {
                    "actionGroups": [
                        "[parameters('actionGroups_actiongroup_logicapp_myrg1_externalid')]"
                    ],
                    "customProperties": {}
                }
            }
        }
    ]
}
TEMPLATE
}

*/








