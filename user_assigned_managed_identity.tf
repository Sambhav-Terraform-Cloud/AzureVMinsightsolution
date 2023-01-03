resource "azurerm_user_assigned_identity" "myUserassignedIdentity" {
  name                = "u-id"
  resource_group_name             = data.azurerm_resource_group.rg.name
  location                        = data.azurerm_resource_group.rg.location
}
