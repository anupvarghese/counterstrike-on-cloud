provider "azurerm" {
  subscription_id = "8af4cf95-72ee-4d74-b5bd-f5b747f7eb95"
  client_id       = "ab334d40-ee40-4a9b-8dcc-409b7ce5cec2"
  tenant_id       = "9dd27dfc-8122-4d16-bae8-0327f555ae78"
  version = "=2.0.0"
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "TERRAFORM-RG01"
  location = "australiaeast"
}

resource "azurerm_virtual_network" "network" {
  name                = "staging-network"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "SubnetOne" {
  name                 = "SubnetOne"
  resource_group_name  =  azurerm_resource_group.rg.name
  virtual_network_name =  azurerm_virtual_network.network.name
  address_prefix       = "10.0.1.0/24"
}

resource "azurerm_subnet" "SubnetTwo" {
  name                 = "SubnetTwo"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.network.name
  address_prefix       = "10.0.2.0/24"
}

resource "azurerm_public_ip" "cspip" {
  name                    = "cspip"
  location                = azurerm_resource_group.rg.location
  resource_group_name     = azurerm_resource_group.rg.name
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30

  tags = {
    environment = "staging"
  }
}

resource "azurerm_network_interface" "demonic" {
  name                = "demo-vm-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "NICConfiguration"
    subnet_id                     =  azurerm_subnet.SubnetTwo.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          =  azurerm_public_ip.cspip.id
  }
}

resource "azurerm_virtual_machine" "csserver" {
  name                  = "demo-vm"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.demonic.id]
  vm_size               = "Standard_DS1_v2"

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
    managed_disk_type = "Standard_LRS"
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
      key_data = file("/Users/anupvarghese/.ssh/id_rsa.pub")
    }
  }

  tags = {
    environment = "staging"
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
        "commandToExecute": "apt-get update && apt-get install -y docker.io && docker run -d -p 26900:26900/udp -p 27020:27020/udp -p 27015:27015/udp -p 27015:27015 -e MAXPLAYERS=32 -e START_MAP=de_dust2 -e SERVER_NAME='my Server Name' -e START_MONEY=16000 -e BUY_TIME=0.25 -e FRIENDLY_FIRE=1 -e ADMIN_STEAM=0:1:1234566 --name cs cs16ds/server:latest +log && exit 0"
    }
SETTINGS


  tags = {
    environment = "staging"
  }
}