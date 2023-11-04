# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster
resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "${azurerm_resource_group.aks_rg.name}-cluster"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = "${azurerm_resource_group.aks_rg.name}-cluster"

  kubernetes_version  = data.azurerm_kubernetes_service_versions.current.latest_version
  node_resource_group = "${azurerm_resource_group.aks_rg.name}-nrg"

  default_node_pool {
    name                        = "systempool"
    vm_size                     = "Standard_D2as_v4"
    # vnet_subnet_id              = azurerm_subnet.aks-default.id # Remove it if you want to create new vnet and subnet
    orchestrator_version        = data.azurerm_kubernetes_service_versions.current.latest_version
    zones                       = [1, 2, 3]
    enable_auto_scaling         = true
    temporary_name_for_rotation = "temppool"
    max_count                   = 3
    min_count                   = 1
    os_disk_size_gb             = 30                        # Minimum 30 GB and maximum 2048 GB
    type                        = "VirtualMachineScaleSets" # AvailabilitySet or VirtualMachineScaleSets
    node_labels = {
      "nodepool-type" = "system-nodepool"
      "environment"   = "dev"
      "nodepools"     = "linux"
      "app"           = "system-apps"
    }
    tags = {
      "nodepool-type" = "system-nodepool"
      "environment"   = "dev"
      "nodepools"     = "linux"
      "app"           = "system-apps"
    }
  }

  # Identity (System Assigned or User Assigned)
  identity {
    type = "SystemAssigned"
  }

  # addon_profiles
  azure_policy_enabled = true
  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.insights.id
  }

  # RBAC and Azure AD Integration Block
  role_based_access_control_enabled = true
  azure_active_directory_role_based_access_control {
    managed                = true
    admin_group_object_ids = [azuread_group.aks_administrators.object_id]
  }

  # Windows Profile
  windows_profile {
    admin_username = var.windows_admin_username
    admin_password = var.windows_admin_password # Minimum 14 characters
  }

  # Linux Profile
  linux_profile {
    admin_username = "ubuntu"
    ssh_key {
      key_data = file("${var.ssh_public_key}")
    }
  }

  # Network Profile
  network_profile {
    network_plugin    = "azure"    # azure, kubenet and none
    load_balancer_sku = "standard" # basic is not working
  }


  tags = {
    Environment = "dev"
  }
}