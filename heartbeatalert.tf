resource "azurerm_resource_group_template_deployment" "heartbeatAlertDeploy" {
  name                 =    "heartbeatAlertDeploy"
  resource_group_name  =     data.azurerm_resource_group.rg.name
  deployment_mode      =     "Incremental"
  parameters_content = jsonencode({
    "actiongroup_id" = { value = azurerm_monitor_action_group.ag.id },
    "name" = { value = "Not reachable -" }
    "scope" = { value = data.azurerm_subscription.current.id }
    "location" = { value = data.azurerm_resource_group.rg.location }
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
        },
        "location": {
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
            "location": "[parameters('location')]",
            "properties": {
                "displayName": "[parameters('name')]",
                "severity": 0,
                "enabled": true,
                "evaluationFrequency": "PT5M",
                "scopes": [
                    "[parameters('scope')]"
                ],
                "windowSize": "PT5M",
                "criteria": {
                    "allOf": [
                        {
                            "query": "Heartbeat\n| summarize LastHeartbeat=max(TimeGenerated) by Computer\n| where LastHeartbeat < ago(2m)\n",
                            "timeAggregation": "Count",
                            "dimensions": [
                                {
                                    "name": "Computer",
                                    "operator": "Include",
                                    "values": [
                                        "*"
                                    ]
                                }
                            ],
                            "operator": "GreaterThan",
                            "threshold": 1,
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
