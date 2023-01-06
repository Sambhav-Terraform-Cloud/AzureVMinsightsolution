data "azurerm_subscription" "current" {}

variable "policy_definition_category" {
  type        = string
  description = "The category to use for all Policy Definitions"
  default     = "Custom"
}

resource "azurerm_policy_definition" "deployAzureMonitoringAgentLinux" {
  name         = "deploy AzureMonitoring Agent Windows"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deploy AzureMonitoringAgents on Linux"
  description  = "Deploy AzureMonitoringAgent on Linux"
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
              "centraluseuap",
              "eastasia",
              "eastus",
              "eastus2",
              "eastus2euap",
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
              "qatarcentral",
              "southafricanorth",
              "southcentralus",
              "southeastasia",
              "southindia",
              "swedencentral",
              "switzerlandnorth",
              "uaenorth",
              "uksouth",
              "ukwest",
              "westcentralus",
              "westeurope",
              "westindia",
              "westus",
              "westus2",
              "westus3"
            ]
          },
          {
            "anyOf": [
              {
                "field": "Microsoft.Compute/imageId",
                "in": "[parameters('listOfLinuxImageIdToInclude')]"
              },
              {
                "allOf": [
                  {
                    "field": "Microsoft.Compute/imagePublisher",
                    "equals": "RedHat"
                  },
                  {
                    "field": "Microsoft.Compute/imageOffer",
                    "in": [
                      "RHEL",
                      "RHEL-ARM64",
                      "RHEL-BYOS",
                      "RHEL-HA",
                      "RHEL-SAP",
                      "RHEL-SAP-APPS",
                      "RHEL-SAP-HA"
                    ]
                  },
                  {
                    "anyOf": [
                      {
                        "field": "Microsoft.Compute/imageSku",
                        "like": "7*"
                      },
                      {
                        "field": "Microsoft.Compute/imageSku",
                        "like": "8*"
                      },
                      {
                        "field": "Microsoft.Compute/imageSku",
                        "like": "rhel-lvm7*"
                      },
                      {
                        "field": "Microsoft.Compute/imageSku",
                        "like": "rhel-lvm8*"
                      }
                    ]
                  }
                ]
              },
              {
                "allOf": [
                  {
                    "field": "Microsoft.Compute/imagePublisher",
                    "equals": "SUSE"
                  },
                  {
                    "anyOf": [
                      {
                        "allOf": [
                          {
                            "field": "Microsoft.Compute/imageOffer",
                            "in": [
                              "SLES",
                              "SLES-HPC",
                              "SLES-HPC-Priority",
                              "SLES-SAP",
                              "SLES-SAP-BYOS",
                              "SLES-Priority",
                              "SLES-BYOS",
                              "SLES-SAPCAL",
                              "SLES-Standard"
                            ]
                          },
                          {
                            "anyOf": [
                              {
                                "field": "Microsoft.Compute/imageSku",
                                "like": "12*"
                              },
                              {
                                "field": "Microsoft.Compute/imageSku",
                                "like": "15*"
                              }
                            ]
                          }
                        ]
                      },
                      {
                        "allOf": [
                          {
                            "anyOf": [
                              {
                                "field": "Microsoft.Compute/imageOffer",
                                "like": "sles-12*"
                              },
                              {
                                "field": "Microsoft.Compute/imageOffer",
                                "like": "sles-15*"
                              }
                            ]
                          },
                          {
                            "field": "Microsoft.Compute/imageSku",
                            "in": [
                              "gen1",
                              "gen2"
                            ]
                          }
                        ]
                      }
                    ]
                  }
                ]
              },
              {
                "allOf": [
                  {
                    "field": "Microsoft.Compute/imagePublisher",
                    "equals": "Canonical"
                  },
                  {
                    "anyOf": [
                      {
                        "field": "Microsoft.Compute/imageOffer",
                        "equals": "UbuntuServer"
                      },
                      {
                        "field": "Microsoft.Compute/imageOffer",
                        "like": "0001-com-ubuntu-server-*"
                      },
                      {
                        "field": "Microsoft.Compute/imageOffer",
                        "like": "0001-com-ubuntu-pro-*"
                      }
                    ]
                  },
                  {
                    "field": "Microsoft.Compute/imageSku",
                    "in": [
                      "14.04.0-lts",
                      "14.04.1-lts",
                      "14.04.2-lts",
                      "14.04.3-lts",
                      "14.04.4-lts",
                      "14.04.5-lts",
                      "16_04_0-lts-gen2",
                      "16_04-lts-gen2",
                      "16.04-lts",
                      "16.04.0-lts",
                      "18_04-lts-arm64",
                      "18_04-lts-gen2",
                      "18.04-lts",
                      "20_04-lts-arm64",
                      "20_04-lts-gen2",
                      "20_04-lts",
                      "22_04-lts-gen2",
                      "22_04-lts",
                      "pro-16_04-lts-gen2",
                      "pro-16_04-lts",
                      "pro-18_04-lts-gen2",
                      "pro-18_04-lts",
                      "pro-20_04-lts-gen2",
                      "pro-20_04-lts",
                      "pro-22_04-lts-gen2",
                      "pro-22_04-lts"
                    ]
                  }
                ]
              },
              {
                "allOf": [
                  {
                    "field": "Microsoft.Compute/imagePublisher",
                    "equals": "Oracle"
                  },
                  {
                    "field": "Microsoft.Compute/imageOffer",
                    "equals": "Oracle-Linux"
                  },
                  {
                    "anyOf": [
                      {
                        "field": "Microsoft.Compute/imageSku",
                        "like": "7*"
                      },
                      {
                        "field": "Microsoft.Compute/imageSku",
                        "like": "8*"
                      }
                    ]
                  }
                ]
              },
              {
                "allOf": [
                  {
                    "field": "Microsoft.Compute/imagePublisher",
                    "equals": "OpenLogic"
                  },
                  {
                    "field": "Microsoft.Compute/imageOffer",
                    "in": [
                      "CentOS",
                      "Centos-LVM",
                      "CentOS-SRIOV"
                    ]
                  },
                  {
                    "anyOf": [
                      {
                        "field": "Microsoft.Compute/imageSku",
                        "like": "6*"
                      },
                      {
                        "field": "Microsoft.Compute/imageSku",
                        "like": "7*"
                      },
                      {
                        "field": "Microsoft.Compute/imageSku",
                        "like": "8*"
                      }
                    ]
                  }
                ]
              },
              {
                "allOf": [
                  {
                    "field": "Microsoft.Compute/imagePublisher",
                    "equals": "cloudera"
                  },
                  {
                    "field": "Microsoft.Compute/imageOffer",
                    "equals": "cloudera-centos-os"
                  },
                  {
                    "field": "Microsoft.Compute/imageSku",
                    "like": "7*"
                  }
                ]
              },
              {
                "allOf": [
                  {
                    "field": "Microsoft.Compute/imagePublisher",
                    "equals": "almalinux"
                  },
                  {
                    "field": "Microsoft.Compute/imageOffer",
                    "equals": "almalinux"
                  },
                  {
                    "field": "Microsoft.Compute/imageSku",
                    "like": "8*"
                  }
                ]
              },
              {
                "allOf": [
                  {
                    "field": "Microsoft.Compute/imagePublisher",
                    "equals": "ctrliqinc1648673227698"
                  },
                  {
                    "field": "Microsoft.Compute/imageOffer",
                    "like": "rocky-8*"
                  },
                  {
                    "field": "Microsoft.Compute/imageSku",
                    "like": "rocky-8*"
                  }
                ]
              },
              {
                "allOf": [
                  {
                    "field": "Microsoft.Compute/imagePublisher",
                    "equals": "credativ"
                  },
                  {
                    "field": "Microsoft.Compute/imageOffer",
                    "in": [
                      "Debian"
                    ]
                  },
                  {
                    "field": "Microsoft.Compute/imageSku",
                    "equals": "9"
                  }
                ]
              },
              {
                "allOf": [
                  {
                    "field": "Microsoft.Compute/imagePublisher",
                    "equals": "Debian"
                  },
                  {
                    "field": "Microsoft.Compute/imageOffer",
                    "in": [
                      "debian-10",
                      "debian-11"
                    ]
                  },
                  {
                    "field": "Microsoft.Compute/imageSku",
                    "in": [
                      "10",
                      "10-gen2",
                      "11",
                      "11-gen2"
                    ]
                  }
                ]
              },
              {
                "allOf": [
                  {
                    "field": "Microsoft.Compute/imagePublisher",
                    "equals": "microsoftcblmariner"
                  },
                  {
                    "field": "Microsoft.Compute/imageOffer",
                    "equals": "cbl-mariner"
                  },
                  {
                    "field": "Microsoft.Compute/imageSku",
                    "in": [
                      "1-gen2",
                      "cbl-mariner-1",
                      "cbl-mariner-2",
                      "cbl-mariner-2-arm64",
                      "cbl-mariner-2-gen2"
                    ]
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
                "equals": "AzureMonitorLinuxAgent"
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
  "id": "/providers/Microsoft.Authorization/policyDefinitions/1afdc4b6-581a-45fb-b630-f1e6051e3e7a",
  "type": "Microsoft.Authorization/policyDefinitions",
  "name": "1afdc4b6-581a-45fb-b630-f1e6051e3e7a"
}
}

resource "azurerm_subscription_policy_assignment" "assignAMALinuxPolicy" {
  name                 = "assignAMAWindwsPolicy"
  policy_definition_id = azurerm_policy_definition.deployAzureMonitoringAgentLinux.id
  subscription_id      = data.azurerm_subscription.current.id
}
