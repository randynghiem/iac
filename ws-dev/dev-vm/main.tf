provider "azurerm" {
  version = "=1.44.0"
}

resource "azurerm_resource_group" "demo" {
  name     = "${var.prefix}-resources"
  location = var.env_location
}

resource "azurerm_virtual_network" "demo" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/24"]
  location            = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name
}

resource "azurerm_subnet" "dev" {
  name                 = "dev"
  resource_group_name  = azurerm_resource_group.demo.name
  virtual_network_name = azurerm_virtual_network.demo.name
  address_prefix       = "10.0.0.0/28"
}

resource "azurerm_network_interface" "dev" {
  name                = "${var.prefix}-dev-nic"
  location            = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name

  ip_configuration {
    name                          = "demodevpip"
    subnet_id                     = azurerm_subnet.dev.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "main" {
  name                          = "${var.prefix}-vm"
  location                      = azurerm_resource_group.demo.location
  resource_group_name           = azurerm_resource_group.demo.name
  network_interface_ids         = [azurerm_network_interface.dev.id]
  vm_size                       = "Standard_F8s_v2"
  delete_os_disk_on_termination = true
  license_type                  = "Windows_Server"

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.prefix}-dev-OsDisk"
    managed_disk_type = "Standard_LRS"
    caching           = "ReadWrite"
    create_option     = "FromImage"
  }

  os_profile {
    computer_name  = "dev01"
    admin_username = var.env_dev_username
    admin_password = var.env_dev_password
  }

  os_profile_windows_config {
    enable_automatic_upgrades = "true"
    provision_vm_agent        = "true"
  }

  tags = {
    environment = "development"
  }
}
