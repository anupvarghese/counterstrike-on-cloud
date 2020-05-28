provider "azurerm" {
  subscription_id = var.subscription_id
  client_id       = var.client_id
  tenant_id       = var.tenant_id
  version = "=2.0.0"
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.region
}

resource "azurerm_virtual_network" "network" {
  name                = "staging-network"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = [var.vpc]
}

resource "azurerm_subnet" "subnet_two" {
  name                 = "subnet_two"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.network.name
  address_prefix       = var.subnet
}

resource "azurerm_public_ip" "cspip" {
  name                    = "cspip"
  location                = azurerm_resource_group.rg.location
  resource_group_name     = azurerm_resource_group.rg.name
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30

  tags = {
    environment = var.environment_tag
  }
}

resource "azurerm_network_interface" "demonic" {
  name                = "demo-vm-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  enable_accelerated_networking = true # works only with certain

  ip_configuration {
    name                          = "NICConfiguration"
    subnet_id                     =  azurerm_subnet.subnet_two.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          =  azurerm_public_ip.cspip.id
  }
}

resource "azurerm_virtual_machine" "csserver" {
  name                  = "demo-vm"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.demonic.id]
  vm_size               = var.vm_size

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = var.storage_disk_type
  }
  os_profile {
    computer_name  = "terraformserver"
    admin_username = "demoadmin"
    admin_password = "PUTASECUREPASSWORDHEREPLEASEFORTHELOVEOFGOD123\\aa"
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path = "/home/demoadmin/.ssh/authorized_keys"
      key_data = file(var.public_key_path)
    }
  }

  tags = {
    environment = var.environment_tag
  }
}

resource "azurerm_virtual_machine_extension" "csserver" {
  name                 = "hostname"
  virtual_machine_id   = azurerm_virtual_machine.csserver.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"


  settings = <<SETTINGS
    {
        "commandToExecute": "apt-get update && apt-get install -y docker.io && docker run -d -p 26900:26900/udp -p 27020:27020/udp -p 27015:27015/udp -p 27015:27015 -e MAXPLAYERS=32 -e START_MAP=de_dust2 -e SERVER_NAME='cop cs server' -e START_MONEY=800 -e BUY_TIME=0.25 -e FRIENDLY_FIRE=1 -e ADMIN_STEAM=0:1:1234566 -e SERVER_PASSWORD=cop123 -e RCON_PASSWORD=awesome --name cs cs16ds/server:latest +log && exit 0"
    }
SETTINGS


  tags = {
    environment = var.environment_tag
  }
}