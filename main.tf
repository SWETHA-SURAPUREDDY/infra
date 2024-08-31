variable "subscription_id" {
  description = "The subscription ID to use for the Azure resources"
  type        = string
}

provider "azurerm" {
  features {}
  # Use the subscription_id from terraform.tfvars file
  subscription_id = var.subscription_id
}

# Create a Resource Group
resource "azurerm_resource_group" "aks_rg" {
  name     = "aks-test-rg"
  location = "East US"
}

# Create a Virtual Network
resource "azurerm_virtual_network" "aks_vnet" {
  name                = "aks-vnet"A
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  address_space       = ["10.0.0.0/16"]
}

# Create a Subnet
resource "azurerm_subnet" "aks_subnet" {
  name                 = "aks-subnet"
  resource_group_name  = azurerm_resource_group.aks_rg.name
  virtual_network_name = azurerm_virtual_network.aks_vnet.name
  address_prefixes     = ["10.0.2.0/24"]  
}

# Create Azure Container Registry
resource "azurerm_container_registry" "acr" {
  name                = "acrsurapureddyswetha"
  resource_group_name = azurerm_resource_group.aks_rg.name
  location            = azurerm_resource_group.aks_rg.location
  sku                 = "Basic"
  admin_enabled       = true
}

# Create AKS Cluster
resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "app-cluster"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = "dotnet"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_DS2_v2"
    vnet_subnet_id = azurerm_subnet.aks_subnet.id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
    service_cidr      = "10.1.0.0/16"  
    dns_service_ip    = "10.1.0.10"   
  }

}

# Assign AKS pull permissions from ACR
resource "azurerm_role_assignment" "aks_acr_pull" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks_cluster.identity[0].principal_id
}



