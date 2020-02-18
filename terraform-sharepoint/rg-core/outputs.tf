output "rg_core_name" {
  value = "${var.rg_name}"
}


output "subnet_tier0" {
  value = "${azurerm_subnet.tier0.id}"
}

output "subnet_tier1" {
  value = "${azurerm_subnet.tier1.id}"
}

output "subnet_tier2" {
  value = "${azurerm_subnet.tier2.id}"
}
