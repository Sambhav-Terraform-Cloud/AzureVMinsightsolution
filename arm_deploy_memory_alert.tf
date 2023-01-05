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
        }
    },
    "variables": {},
    "resources": [
        {
            "type": "microsoft.insights/scheduledqueryrules",
            "apiVersion": "2022-06-15",
            "name": "[parameters('scheduledqueryrules_Memalert_name')]",
            "location": "eastus",
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










