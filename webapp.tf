resource "random_string" "webapprnd" {
    length = 8
    lower = true
    upper = false
    number = true
    special = false
  }

resource "azurerm_resource_group" "webapp" {
  name = "webapp"
  location = "${var.loc}"
  tags = "${var.tags}"
}

resource "azurerm_app_service_plan" "free" {
  name = "plan-free-${var.loc}"
  resource_group_name = "${azurerm_resource_group.webapp.name}"
  location = "${var.loc}"
  tags = "${var.tags}"

  kind = "linux"
  reserved = true
    sku {
    tier = "Free"
    size = "F1"
  }
}

  resource "azurerm_app_service" "citadel" {
    name                = "webapp-${random_string.webapprnd.result}-${var.loc}"
    location            = "${var.loc}"
    resource_group_name = "${azurerm_resource_group.webapp.name}"
    tags                = "${azurerm_resource_group.webapp.tags}"

    app_service_plan_id = "${azurerm_app_service_plan.free.id}"
}