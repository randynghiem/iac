provider "azurerm" {
  version = "1.20.0"
}
module "shared" {
  source = "../module/shared"
}

resource "azurerm_resource_group" "rncore" {
  name     = "${var.rg_name}"
  location = "${module.shared.rn_location}"
}

resource "azurerm_virtual_network" "vpn" {
  name                = "${module.shared.rn_vpn_name}"
  address_space       = ["10.0.0.0/8"]
  location            = "${azurerm_resource_group.rncore.location}"
  resource_group_name = "${var.rg_name}"
  dns_servers         = ["10.0.0.8", "8.8.8.8"]
}

resource "azurerm_subnet" "tier0" {
  name                      = "tier0"
  resource_group_name       = "${var.rg_name}"
  virtual_network_name      = "${azurerm_virtual_network.vpn.name}"
  address_prefix            = "10.0.0.0/24"
}

resource "azurerm_subnet" "tier1" {
  name                 = "tier1"
  resource_group_name  = "${var.rg_name}"
  virtual_network_name = "${azurerm_virtual_network.vpn.name}"
  address_prefix       = "10.1.0.0/24"
}

resource "azurerm_subnet" "tier2" {
  name                 = "tier2"
  resource_group_name  = "${var.rg_name}"
  virtual_network_name = "${azurerm_virtual_network.vpn.name}"
  address_prefix       = "10.2.0.0/24"
}

module "LabDC01" {
  source                        = "../module/vm-dc"
  resource_group_name           = "${azurerm_resource_group.rncore.name}"
  location                      = "${azurerm_resource_group.rncore.location}"
  subnet_id                     = "${azurerm_subnet.tier0.id}"
  active_directory_domain       = "lab.local"
  active_directory_netbios_name = "lab"
  admin_username                = "${module.shared.rn_admin_user}"
  admin_password                = "${var.rn_password}"
  private_ip_address            = "10.0.0.8"
  vm_name                       = "LabDC01"
}

module "LabDB01" {
  source                    = "../module/vm-db"
  resource_group_name       = "${azurerm_resource_group.rncore.name}"
  location                  = "${azurerm_resource_group.rncore.location}"
  subnet_id                 = "${azurerm_subnet.tier1.id}"
  admin_username            = "${module.shared.rn_admin_user}"
  admin_password            = "${var.rn_password}"
  private_ip_address        = "10.1.0.8"
  vm_name                   = "LabDB01"
}

module "LabWFE01" {
  source                    = "../module/vm-db"
  resource_group_name       = "${azurerm_resource_group.rncore.name}"
  location                  = "${azurerm_resource_group.rncore.location}"
  subnet_id                 = "${azurerm_subnet.tier2.id}"
  admin_username            = "${module.shared.rn_admin_user}"
  admin_password            = "${var.rn_password}"
  private_ip_address        = "10.2.0.8"
  vm_name                   = "LabWFE01"
}