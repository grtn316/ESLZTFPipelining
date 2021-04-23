# Use variables to customise the deployment

variable "root_parent_id" { #REQUIRED: The root_parent_id is used to specify where to set the root for all Landing Zone deployments. Usually the Tenant ID when deploying the core Enterprise-scale Landing Zones.
  type    = string
  default = null
}

variable "root_id" { #OPTIONAL: If specified, will set a custom Name (ID) value for the Enterprise-scale "root" Management Group, and append this to the ID for all core Enterprise-scale Management Groups.
  type    = string
  default = "escustom"
}

variable "root_name" { #OPTIONAL: If specified, will set a custom DisplayName value for the Enterprise-scale "root" Management Group.
  type    = string
  default = "ESLZ Root Custom"
}

variable "archetype_config_overrides" { # OPTIONAL: If specified, will set custom Archetype configurations to the default Enterprise-scale Management Groups.
  type    = map(any)
  default = {}
}

variable "create_duration_delay" { #OPTIONAL: Used to tune terraform apply when faced with errors caused by API caching or eventual consistency. Sets a custom delay period after creation of the specified resource type.
  type = map(string)
  default = {
    azurerm_management_group      = "30s"
    azurerm_policy_assignment     = "30s"
    azurerm_policy_definition     = "30s"
    azurerm_policy_set_definition = "30s"
    azurerm_role_assignment       = "0s"
    azurerm_role_definition       = "60s"
  }
}

variable "custom_landing_zones" { #OPTIONAL: If specified, will deploy additional Management Groups alongside Enterprise-scale core Management Groups.
  type    = map(object({ display_name = string, parent_management_group_id = string, subscription_ids = list(string), archetype_config = object({ archetype_id = string, parameters = any, access_control = any }) }))
  default = {}
}

variable "default_location" { #OPTIONAL: If specified, will use set the default location used for resource deployments where needed.
  type    = string
  default = "eastus"
}

variable "deploy_core_landing_zones" { #OPTIONAL: If set to true, will include the core Enterprise-scale Management Group hierarchy.
  type    = bool
  default = false
}

variable "deploy_demo_landing_zones" { #OPTIONAL: If set to true, will include the demo "Landing Zone" Management Groups.
  type    = bool
  default = false
}

variable "destroy_duration_delay" { #OPTIONAL: Used to tune terraform deploy when faced with errors caused by API caching or eventual consistency. Sets a custom delay period after destruction of the specified resource type.
  type = map(string)
  default = {
    azurerm_management_group      = "0s"
    azurerm_policy_assignment     = "0s"
    azurerm_policy_definition     = "0s"
    azurerm_policy_set_definition = "0s"
    azurerm_role_assignment       = "0s"
    azurerm_role_definition       = "0s"
  }
}

variable "library_path" { #OPTIONAL: If specified, sets the path to a custom library folder for archetype artefacts.
  type    = string
  default = ""
}

variable "subscription_id_overrides" { #OPTIONAL: If specified, will be used to assign subscription_ids to the default Enterprise-scale Management Groups.
  type = map(list(string))
  default = {
    root           = [],
    decommissioned = [],
    sandboxes      = [],
    landing-zones  = [],
    platform       = [],
    connectivity   = [],
    management     = [],
    identity       = []
  }
}

variable "template_file_variables" { #OPTIONAL: If specified, provides the ability to define custom template variables used when reading in template files from the built-in and custom library_path.
  type    = map(any)
  default = {}
}
