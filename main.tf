variable "arm_subscription_id" {}
variable "arm_client_id" {}
variable "arm_client_secret" {}
variable "arm_tenant_id" {}

provider "azurerm" {
  version = "=2.20.0"

  features {}

  subscription_id = var.arm_subscription_id
  client_id = var.arm_client_id
  client_secret = var.arm_client_secret
  tenant_id = var.arm_tenant_id
}

data "azurerm_image" "us_api" {
    name = "us1804-api-image"
    resource_group_name = "api-portal-images"
}

data "azurerm_image" "us_db" {
    name = "us1804-db-image"
    resource_group_name = "api-portal-images"
}

resource "azurerm_resource_group" "default" {
  name = "api-portal-rg"
  location = "eastus"
}

resource "azurerm_virtual_network" "default" {
  name = "v-net"
  address_space = ["20.0.0.0/24"]
  location = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
}

resource "azurerm_subnet" "default" {
  name = "default-subnet"
  resource_group_name = azurerm_resource_group.default.name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes = ["20.0.0.0/24"]
}

resource "azurerm_public_ip" "api" {
  name = "api-pubip"
  location = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  allocation_method   = "Dynamic"
}

resource "azurerm_public_ip" "db" {
  name = "db-pubip"
  location = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_security_group" "api" {
  name = "api-nsg"
  location = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name

  security_rule {
    name = "api-http"
    priority = 100
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "3010"
    source_address_prefix = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name = "ssh"
    priority = 150
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "22"
    source_address_prefix = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "db" {
  name = "db-nsg"
  location = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name

  security_rule {
    name = "ssh"
    priority = 150
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "22"
    source_address_prefix = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "api" {
  name = "api-nic"
  location = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name

  ip_configuration {
      name = "api-nic-config"
      subnet_id = azurerm_subnet.default.id
      private_ip_address_allocation = "static"
      private_ip_address = "20.0.0.10"
      public_ip_address_id = azurerm_public_ip.api.id
  }
}

resource "azurerm_network_interface" "db" {
  name = "db-nic"
  location = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name

  ip_configuration {
      name = "db-nic-config"
      subnet_id = azurerm_subnet.default.id
      private_ip_address_allocation = "static"
      private_ip_address = "20.0.0.11"
      public_ip_address_id = azurerm_public_ip.db.id
  }
}

resource "azurerm_virtual_machine" "api" {
  name = "api-vm"
  location = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  vm_size = "Standard_B1s"
  network_interface_ids = [azurerm_network_interface.api.id]

  storage_image_reference {
    id = data.azurerm_image.us_api.id
  }

  storage_os_disk {
    name          = "api-disk"
    create_option = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "api-vm"
    admin_username = "azuser"
    admin_password = "a8p6e423p"
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path = "/home/azuser/.ssh/authorized_keys"
      key_data = file("~/.ssh/id_rsa.pub")
    }
  }
}

resource "azurerm_virtual_machine" "db" {
  name = "db-vm"
  location = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  vm_size = "Standard_B1ms"
  network_interface_ids = [azurerm_network_interface.db.id]

  storage_image_reference {
    id = data.azurerm_image.us_db.id
  }

  storage_os_disk {
    name          = "db-disk"
    create_option = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "db-vm"
    admin_username = "azuser"
    admin_password = "db-vm-12345"
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path = "/home/azuser/.ssh/authorized_keys"
      key_data = file("~/.ssh/id_rsa.pub")
    }    
  }
}

data "azurerm_public_ip" "api" {
  name                = azurerm_public_ip.api.name
  resource_group_name = azurerm_virtual_machine.api.resource_group_name
}

data "azurerm_public_ip" "db" {
  name                = azurerm_public_ip.db.name
  resource_group_name = azurerm_virtual_machine.db.resource_group_name
}

output "api-vm-ip" {
  value = data.azurerm_public_ip.api.ip_address
}

output "db-vm-ip" {
  value = data.azurerm_public_ip.db.ip_address
}