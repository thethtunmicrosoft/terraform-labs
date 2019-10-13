resource "azurerm_resource_group" "coretf" {
    name = "corersg"
    location = "${var.loc}"
    tags = "${var.tags}"

     
}
resource "azurerm_virtual_network" "core" {
  name                = "corevnet"
  location            = "${var.loc}"
  resource_group_name = "${azurerm_resource_group.coretf.name}"
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["1.1.1.1","1.0.0.1"]
}

resource "azurerm_public_ip" "vpnGatewayPublicIp" {
  name = "vpnpublicip"
  location = "${var.loc}"
  tags = "${var.tags}"
  resource_group_name = "${azurerm_resource_group.coretf.name}"
  public_ip_address_allocation = "Dynamic"
}

resource "azurerm_subnet" "Gatewaysubnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = "${azurerm_resource_group.coretf.name}"
  virtual_network_name = "${azurerm_virtual_network.core.name}"
  address_prefix       = "10.0.0.0/24"
}

resource "azurerm_subnet" "training" {
  name                 = "training"
  resource_group_name  = "${azurerm_resource_group.coretf.name}"
  virtual_network_name = "${azurerm_virtual_network.core.name}"
  address_prefix       = "10.0.1.0/24"
}
 
 resource "azurerm_subnet" "dev" {
  name                 = "dev"
  resource_group_name  = "${azurerm_resource_group.coretf.name}"
  virtual_network_name = "${azurerm_virtual_network.core.name}"
  address_prefix       = "10.0.2.0/24"
}



resource "azurerm_virtual_network_gateway" "vpnGateway" {
  name = "vpnGateway"
  location = "${var.loc}"
  tags = "${var.tags}"
  resource_group_name = "${azurerm_resource_group.coretf.name}"
  type = "vpn"
  vpn_type = "Routebased"
  enable_bgp = true
  sku = "Basic"

  ip_configuration {
      name = "vpnGwConfig"
      public_ip_address_id = "${azurerm_public_ip.vpnGatewayPublicIp.id}"
      private_ip_address_allocation = "Dynamic"
      subnet_id = "${azurerm_subnet.Gatewaysubnet.id}"

}
}