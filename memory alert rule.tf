resource "azurerm_resource_group_template_deployment" "memAlertDeploy" {
  name                 =    "memAlertDeploy"
  resource_group_name  =     data.azurerm_resource_group.rg.name
  deployment_mode      =     "Incremental"
  parameters_content = jsonencode({
    "actiongroup_id" = { value = azurerm_monitor_action_group.ag.id },
    "name" = { value = "High Memory Usage Alert (Details in Comments)" }
    "scope" = { value = data.azurerm_subscription.current.id }
  })
  template_content  =     <<TEMPLATE

 {
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "name": {
            "defaultValue": "",
            "type": "String"
        },
        "scope": {
            "defaultValue": "",
            "type": "String"
        },
        "actiongroup_id": {
            "defaultValue": "",
            "type": "String"
        }
    },
    "variables": {},
    "resources": [
        {
            "type": "microsoft.insights/scheduledqueryrules",
            "apiVersion": "2022-06-15",
            "name": "[parameters('name')]",
            "location": "eastus",
            "properties": {
                "displayName": "[parameters('name')]",
                "description": "[parameters('name')]",
                "severity": 1,
                "enabled": true,
                "evaluationFrequency": "PT5M",
                "scopes": [
                    "[parameters('scope')]"
                ],
                "windowSize": "PT5M",
                "overrideQueryTimeRange": "P2D",
                "criteria": {
                    "allOf": [
                        {
                            "query": "let MinTime = ago(2m);\nInsightsMetrics\n| where TimeGenerated > MinTime \n| where Origin == \"vm.azm.ms\"\n| where Namespace == \"Memory\" and Name == \"AvailableMB\"\n| extend TotalMemory = toreal(todynamic(Tags)[\"vm.azm.ms/memorySizeMB\"]) | extend AvailableMemoryPercentage = (toreal(Val) / TotalMemory) * 100.0\n| summarize AggregatedValue = avg(AvailableMemoryPercentage) by bin(TimeGenerated, 15m), Computer, _ResourceId\n| where AggregatedValue >= 90\n| project Computer, _ResourceId ,AggregatedValue",
                            "timeAggregation": "Maximum",
                            "metricMeasureColumn": "AggregatedValue",
                            "dimensions": [],
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
                "autoMitigate": true,
                "actions": {
                    "actionGroups": [
                        "[parameters('actiongroup_id')]"
                    ],
                    "customProperties": {}
                }
            }
        }
    ]
}
  
TEMPLATE
}
