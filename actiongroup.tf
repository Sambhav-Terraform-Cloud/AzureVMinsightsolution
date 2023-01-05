resource "azurerm_resource_group_template_deployment" "logic_app_endpoint" {
name = "${local.logicappname}_endpoint"
resource_group_name = data.azurerm_resource_group.rg.name
deployment_mode = "Incremental"
depends_on = [
    azurerm_resource_group_template_deployment.logicappdeploy
  ]
template_content = <<DEPLOY
  
{
"$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
"contentVersion": "1.0.0.0",
"variables": {
"logicApp": {
"name": "${local.logicappname}",
"trigger": "manual"
},
"resourceId": "[resourceId('Microsoft.Logic/workflows/triggers', variables('logicApp').name, variables('logicApp').trigger)]",
"apiVersion": "[providers('Microsoft.Logic', 'workflows').apiVersions[0]]"
},
"resources": [],
"outputs": {
"endpointUrl": {
"type": "string",
"value": "[listCallbackUrl(variables('resourceId'), variables('apiVersion')).value]"
}
}
}
DEPLOY

}

resource "azurerm_monitor_action_group" "ag" {
  name                = "actiongroup-${local.logicappname}"
  resource_group_name = data.azurerm_resource_group.rg.name
  short_name          = "ag-lgapp"


  logic_app_receiver {
    name                    = local.logicappname
    resource_id             = data.azurerm_logic_app_workflow.existing_logicapp.id
    callback_url = jsondecode(azurerm_resource_group_template_deployment.logic_app_endpoint.output_content).endpointUrl.value
    use_common_alert_schema = true
  }
}
