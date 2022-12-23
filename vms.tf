
resource "azurerm_virtual_network" "myVnet" {
  name                = "myVnet1"
  address_space       = ["10.0.0.0/16"]
  resource_group_name             = data.azurerm_resource_group.rg.name
  location                        = data.azurerm_resource_group.rg.location
}

resource "azurerm_subnet" "mySubnet" {
  name                 = "mySubnet1"
  resource_group_name             = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.myVnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "myNic" {
  name                = "myNic1"
  resource_group_name             = data.azurerm_resource_group.rg.name
  location                        = data.azurerm_resource_group.rg.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.mySubnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Windows VM
resource "azurerm_windows_virtual_machine" "myWindowsVm1" {
  name                            = "mywindowsvm1"
  computer_name                   = "mywindowsvm1"
  resource_group_name             = data.azurerm_resource_group.rg.name
  location                        = data.azurerm_resource_group.rg.location
  size                            = "Standard_B2s"
  admin_username                  = "adminlogin"
  admin_password                  = "Password@123"
  identity { type = "SystemAssigned" }

  network_interface_ids = [
    azurerm_network_interface.myNic.id,
  ]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
 
}

resource "azurerm_linux_virtual_machine" "myLinuxVm1" {
  name                = "mylinuxvm1"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  size                = "Standard_B2s"
  admin_username      = "adminuser"
  admin_password      = "Password@123"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.myNic.id,
  ]
  
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}
