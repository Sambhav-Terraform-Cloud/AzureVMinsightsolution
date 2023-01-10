resource "azurerm_resource_group_template_deployment" "memAlertDeploy" {
  name                 =    "memAlertDeploy"
  resource_group_name  =     data.azurerm_resource_group.rg.name
  deployment_mode      =     "Incremental"
  parameters_content = jsonencode({
    "actiongroup_id" = { value = azurerm_monitor_action_group.ag.id},
    "name" = { value = "Free Space Alert (Details in Work Notes)" }
    "scope" = "/subscriptions/${data.azurerm_subscription.current.id}"
  })
  template_content  =     <<TEMPLATE

 {
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "name": {
            "defaultValue": "Free Space Alert (Details in Work Notes)",
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
                            "query": "let MinTime = ago(1m);\nInsightsMetrics\n| where Namespace == \"LogicalDisk\" and Name == \"FreeSpacePercentage\"\n| where TimeGenerated > MinTime\n| project\n    Computer,\n    _ResourceId,\n    TimeGenerated,\n    Val,\n    extract('(.*:\")(.*)(\"})', 2, Tags, typeof(string))\n\n",
                            "timeAggregation": "Maximum",
                            "metricMeasureColumn": "Val",
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
                        "[parameters('actiongroups_actiongroup_logicapp_myrg1_externalid')]"
                    ],
                    "customProperties": {}
                }
            }
        }
    ]
}
  
TEMPLATE
}
