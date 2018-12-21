resource "azurerm_public_ip" "static" {
  name                         = "${var.vm_name}-pip"
  location                     = "${var.location}"
  resource_group_name          = "${var.resource_group_name}"
  public_ip_address_allocation = "static"
}

resource "azurerm_network_interface" "primary" {
  name                    = "${var.vm_name}-nic"
  location                = "${var.location}"
  resource_group_name     = "${var.resource_group_name}"
  internal_dns_name_label = "${local.virtual_machine_name}"

  ip_configuration {
    name                          = "primary"
    subnet_id                     = "${var.subnet_id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "${var.private_ip_address}"
    public_ip_address_id          = "${azurerm_public_ip.static.id}"
  }
}
