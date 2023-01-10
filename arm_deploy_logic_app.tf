resource "azurerm_resource_group_template_deployment" "logicappdeploy" {
  name                 =    "deployment-${local.logicappname}"
  resource_group_name  =     data.azurerm_resource_group.rg.name
  deployment_mode      =     "Incremental"
  parameters_content = jsonencode({
    "logic_app_name" = { value = local.logicappname }
    "location" = { value = var.location }
    "username" = { value = var.snow_username}
    "password" = { value = var.snow_password}
    "servicenowurl" = { value = var.snow_url}
  })
  template_content  =     <<TEMPLATE

  {
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "logic_app_name": {
            "defaultValue": "logicappsnow2",
            "type": "String"
        },
      "location": {
            "defaultValue": "central us",
            "type": "String"
        },
      "username": {
            "defaultValue": "abc",
            "type": "String"
        },
      "password": {
            "defaultValue": "abc",
            "type": "String"
        },
      "servicenowurl": {
            "defaultValue": "abc",
            "type": "String" 
      }
    },
    "variables": {},
    "resources": [
        {
            "type": "Microsoft.Logic/workflows",
            "apiVersion": "2017-07-01",
            "name": "[parameters('logic_app_name')]",
            "location": "[parameters('location')]",
            "properties": {
                "state": "Enabled",
                "definition": {
                    "$schema": "https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#",
                    "contentVersion": "1.0.0.0",
                    "parameters": {},
                    "triggers": {
                        "manual": {
                            "type": "Request",
                            "kind": "Http",
                            "inputs": {
                                "schema": {
                                    "properties": {
                                        "data": {
                                            "properties": {
                                                "alertContext": {
                                                    "properties": {
                                                        "condition": {
                                                            "properties": {
                                                                "allOf": {
                                                                    "items": {
                                                                        "properties": {
                                                                            "dimensions": {
                                                                                "items": {
                                                                                    "properties": {
                                                                                        "name": {
                                                                                            "type": "string"
                                                                                        },
                                                                                        "value": {
                                                                                            "type": "string"
                                                                                        }
                                                                                    },
                                                                                    "required": [
                                                                                        "name",
                                                                                        "value"
                                                                                    ],
                                                                                    "type": "object"
                                                                                },
                                                                                "type": "array"
                                                                            },
                                                                            "metricName": {
                                                                                "type": "string"
                                                                            },
                                                                            "metricNamespace": {
                                                                                "type": "string"
                                                                            },
                                                                            "metricValue": {
                                                                                "type": "number"
                                                                            },
                                                                            "operator": {
                                                                                "type": "string"
                                                                            },
                                                                            "threshold": {
                                                                                "type": "string"
                                                                            },
                                                                            "timeAggregation": {
                                                                                "type": "string"
                                                                            }
                                                                        },
                                                                        "required": [
                                                                            "metricName",
                                                                            "metricNamespace",
                                                                            "operator",
                                                                            "threshold",
                                                                            "timeAggregation",
                                                                            "dimensions",
                                                                            "metricValue"
                                                                        ],
                                                                        "type": "object"
                                                                    },
                                                                    "type": "array"
                                                                },
                                                                "windowSize": {
                                                                    "type": "string"
                                                                }
                                                            },
                                                            "type": "object"
                                                        },
                                                        "conditionType": {
                                                            "type": "string"
                                                        },
                                                        "properties": {}
                                                    },
                                                    "type": "object"
                                                },
                                                "essentials": {
                                                    "properties": {
                                                        "alertContextVersion": {
                                                            "type": "string"
                                                        },
                                                        "alertId": {
                                                            "type": "string"
                                                        },
                                                        "alertRule": {
                                                            "type": "string"
                                                        },
                                                        "alertTargetIDs": {
                                                            "items": {
                                                                "type": "string"
                                                            },
                                                            "type": "array"
                                                        },
                                                        "configurationItems": {
                                                            "items": {
                                                                "type": "string"
                                                            },
                                                            "type": "array"
                                                        },
                                                        "description": {
                                                            "type": "string"
                                                        },
                                                        "essentialsVersion": {
                                                            "type": "string"
                                                        },
                                                        "firedDateTime": {
                                                            "type": "string"
                                                        },
                                                        "monitorCondition": {
                                                            "type": "string"
                                                        },
                                                        "monitoringService": {
                                                            "type": "string"
                                                        },
                                                        "originAlertId": {
                                                            "type": "string"
                                                        },
                                                        "resolvedDateTime": {
                                                            "type": "string"
                                                        },
                                                        "severity": {
                                                            "type": "string"
                                                        },
                                                        "signalType": {
                                                            "type": "string"
                                                        }
                                                    },
                                                    "type": "object"
                                                }
                                            },
                                            "type": "object"
                                        },
                                        "schemaId": {
                                            "type": "string"
                                        }
                                    },
                                    "type": "object"
                                }
                            }
                        }
                    },
                    "actions": {
                        "For_each": {
                            "foreach": "@triggerBody()?['data']?['alertContext']?['condition']?['allOf']",
                            "actions": {
                                "HTTP": {
                                    "runAfter": {},
                                    "type": "Http",
                                    "inputs": {
                                        "authentication": {
                                            "password": "[parameters('password')]",
                                            "type": "Basic",
                                            "username": "[parameters('username')]"
                                        },
                                        "body": {
                                            "Priority": 1,
                                            "assigned_to": "",
                                            "caller_id": "azurelogicapp",
                                            "cmdb_ci": "",
                                            "comments": "[[code]<table border='1'><tr><td>Resource Name</td><td> @{triggerBody()?['data']?['essentials']?['alertTargetIDs']} </td></tr><tr><td>Thresold</td><td> @{items('For_each')?['threshold']}</td></tr><tr><td>Time Generated (UTC)</td><td> @{triggerBody()?['data']?['essentials']?['firedDateTime']}</td></tr><tr><td>Current metric Value (When alert was fired)</td><td>@{items('For_each')?['metricValue']} </td></tr></table>[/code]",
                                            "description": "",
                                            "severity": "@{triggerBody()?['data']?['essentials']?['severity']}",
                                            "short_description": "@{triggerBody()?['data']?['essentials']?['description']} ",
                                            "sys_class_name": "incident",
                                            "urgency": 1,
                                            "work_notes": ""
                                        },
                                        "headers": {
                                            "Accept": "application/json",
                                            "Content-Type": "application/json"
                                        },
                                        "method": "POST",
                                        "uri": "[parameters('servicenowurl')]"
                                    }
                                }
                            },
                            "runAfter": {
                                "Initialize_variable": [
                                    "Succeeded"
                                ]
                            },
                            "type": "Foreach"
                        },
                        "Initialize_variable": {
                            "runAfter": {},
                            "type": "InitializeVariable",
                            "inputs": {
                                "variables": [
                                    {
                                        "name": "ResourceName",
                                        "type": "array",
                                        "value": "@triggerBody()?['data']?['essentials']?['configurationItems']"
                                    }
                                ]
                            }
                        }
                    },
                    "outputs": {}
                },
                "parameters": {}
            }
        }
    ]
}
  
TEMPLATE
}

/*
output "my_logicapp" {
  value = data.azurerm_logic_app_workflow.existing_logicapp
} 
*/
