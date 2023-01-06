data "azurerm_subscription" "current" {}

variable "policy_definition_category" {
  type        = string
  description = "The category to use for all Policy Definitions"
  default     = "Custom"
}

resource "azurerm_policy_definition" "deployAzureMonitoringAgentWindows" {
  name         = "deploy AzureMonitoringAgent"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deploy AzureMonitoringAgents on Windows"
  description  = "Deploy AzureMonitoringAgent on Windows"
    parameters = jsonencode({
     "effect" : {
      "type" : "String",
      "metadata" : {
        "displayName" : "effect",
        "description" : "The effect action for the policy."
      },
      "allowedValues" : [
        "DeployIfNotExists",
        "Deny"
      ],
      "defaultValue" : "DeployIfNotExists"
    }
    }
  )

  metadata = <<METADATA
    {
    "category": "${var.policy_definition_category}",
    "version" : "1.0.0"
    }

METADATA


  policy_rule = <<POLICY_RULE
    {
      "if": {
        "allOf": [
          {
            "field": "type",
            "equals": "Microsoft.Compute/virtualMachines"
          },
          {
            "field": "location",
            "in": [
              "australiacentral",
              "australiaeast",
              "australiasoutheast",
              "brazilsouth",
              "canadacentral",
              "canadaeast",
              "centralindia",
              "centralus",
              "eastasia",
              "eastus2euap",
              "eastus",
              "eastus2",
              "francecentral",
              "germanywestcentral",
              "japaneast",
              "japanwest",
              "jioindiawest",
              "koreacentral",
              "koreasouth",
              "northcentralus",
              "northeurope",
              "norwayeast",
              "southafricanorth",
              "southcentralus",
              "southeastasia",
              "southindia",
              "switzerlandnorth",
              "uaenorth",
              "uksouth",
              "ukwest",
              "westcentralus",
              "westeurope",
              "westindia",
              "westus",
              "westus2"
            ]
          },
          {
            "anyOf": [
              {
                "field": "Microsoft.Compute/imageId",
                "in": "[parameters('listOfWindowsImageIdToInclude')]"
              },
              {
                "allOf": [
                  {
                    "field": "Microsoft.Compute/imagePublisher",
                    "equals": "MicrosoftWindowsServer"
                  },
                  {
                    "field": "Microsoft.Compute/imageOffer",
                    "equals": "WindowsServer"
                  },
                  {
                    "anyOf": [
                      {
                        "field": "Microsoft.Compute/imageSku",
                        "like": "2008-R2-SP1*"
                      },
                      {
                        "field": "Microsoft.Compute/imageSku",
                        "like": "2012-*"
                      },
                      {
                        "field": "Microsoft.Compute/imageSku",
                        "like": "2016-*"
                      },
                      {
                        "field": "Microsoft.Compute/imageSku",
                        "like": "2019-*"
                      },
                      {
                        "field": "Microsoft.Compute/imageSku",
                        "like": "2022-*"
                      }
                    ]
                  }
                ]
              },
              {
                "allOf": [
                  {
                    "field": "Microsoft.Compute/imagePublisher",
                    "equals": "MicrosoftWindowsServer"
                  },
                  {
                    "field": "Microsoft.Compute/imageOffer",
                    "equals": "WindowsServerSemiAnnual"
                  },
                  {
                    "field": "Microsoft.Compute/imageSKU",
                    "in": [
                      "Datacenter-Core-1709-smalldisk",
                      "Datacenter-Core-1709-with-Containers-smalldisk",
                      "Datacenter-Core-1803-with-Containers-smalldisk"
                    ]
                  }
                ]
              },
              {
                "allOf": [
                  {
                    "field": "Microsoft.Compute/imagePublisher",
                    "equals": "MicrosoftWindowsServerHPCPack"
                  },
                  {
                    "field": "Microsoft.Compute/imageOffer",
                    "equals": "WindowsServerHPCPack"
                  }
                ]
              },
              {
                "allOf": [
                  {
                    "field": "Microsoft.Compute/imagePublisher",
                    "equals": "MicrosoftSQLServer"
                  },
                  {
                    "anyOf": [
                      {
                        "field": "Microsoft.Compute/imageOffer",
                        "like": "*-WS2022"
                      },
                      {
                        "field": "Microsoft.Compute/imageOffer",
                        "like": "*-WS2022-BYOL"
                      },
                      {
                        "field": "Microsoft.Compute/imageOffer",
                        "like": "*-WS2019"
                      },
                      {
                        "field": "Microsoft.Compute/imageOffer",
                        "like": "*-WS2019-BYOL"
                      },
                      {
                        "field": "Microsoft.Compute/imageOffer",
                        "like": "*-WS2016"
                      },
                      {
                        "field": "Microsoft.Compute/imageOffer",
                        "like": "*-WS2016-BYOL"
                      },
                      {
                        "field": "Microsoft.Compute/imageOffer",
                        "like": "*-WS2012R2"
                      },
                      {
                        "field": "Microsoft.Compute/imageOffer",
                        "like": "*-WS2012R2-BYOL"
                      }
                    ]
                  }
                ]
              },
              {
                "allOf": [
                  {
                    "field": "Microsoft.Compute/imagePublisher",
                    "equals": "MicrosoftRServer"
                  },
                  {
                    "field": "Microsoft.Compute/imageOffer",
                    "equals": "MLServer-WS2016"
                  }
                ]
              },
              {
                "allOf": [
                  {
                    "field": "Microsoft.Compute/imagePublisher",
                    "equals": "MicrosoftVisualStudio"
                  },
                  {
                    "field": "Microsoft.Compute/imageOffer",
                    "in": [
                      "VisualStudio",
                      "Windows"
                    ]
                  }
                ]
              },
              {
                "allOf": [
                  {
                    "field": "Microsoft.Compute/imagePublisher",
                    "equals": "MicrosoftDynamicsAX"
                  },
                  {
                    "field": "Microsoft.Compute/imageOffer",
                    "equals": "Dynamics"
                  },
                  {
                    "field": "Microsoft.Compute/imageSKU",
                    "equals": "Pre-Req-AX7-Onebox-U8"
                  }
                ]
              },
              {
                "allOf": [
                  {
                    "field": "Microsoft.Compute/imagePublisher",
                    "equals": "microsoft-ads"
                  },
                  {
                    "field": "Microsoft.Compute/imageOffer",
                    "equals": "windows-data-science-vm"
                  }
                ]
              },
              {
                "allOf": [
                  {
                    "field": "Microsoft.Compute/imagePublisher",
                    "equals": "MicrosoftWindowsDesktop"
                  },
                  {
                    "field": "Microsoft.Compute/imageOffer",
                    "equals": "Windows-10"
                  }
                ]
              }
            ]
          }
        ]
      },
      "then": {
        "effect": "[parameters('effect')]",
        "details": {
          "type": "Microsoft.Compute/virtualMachines/extensions",
          "existenceCondition": {
            "allOf": [
              {
                "field": "Microsoft.Compute/virtualMachines/extensions/type",
                "equals": "AzureMonitorWindowsAgent"
              },
              {
                "field": "Microsoft.Compute/virtualMachines/extensions/publisher",
                "equals": "Microsoft.Azure.Monitor"
              },
              {
                "field": "Microsoft.Compute/virtualMachines/extensions/provisioningState",
                "equals": "Succeeded"
              }
            ]
          }
        }
      }
    }
  },
  "id": "/providers/Microsoft.Authorization/policyDefinitions/c02729e5-e5e7-4458-97fa-2b5ad0661f28",
  "type": "Microsoft.Authorization/policyDefinitions",
  "name": "c02729e5-e5e7-4458-97fa-2b5ad0661f28"
}

resource "azurerm_subscription_policy_assignment" "assignAMAWindwsPolicy" {
  name                 = "assignAMAWindwsPolicy"
  policy_definition_id = azurerm_policy_definition.deployAzureMonitoringAgentWindows.id
  subscription_id      = data.azurerm_subscription.current.id
}
