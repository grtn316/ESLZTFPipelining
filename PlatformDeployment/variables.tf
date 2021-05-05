# Use variables to customise the deployment

variable "root_parent_id" { #REQUIRED: The root_parent_id is used to specify where to set the root for all Landing Zone deployments. Usually the Tenant ID when deploying the core Enterprise-scale Landing Zones.
  type    = string
  default = null
}

variable "root_id" { #OPTIONAL: If specified, will set a custom Name (ID) value for the Enterprise-scale "root" Management Group, and append this to the ID for all core Enterprise-scale Management Groups.
  type    = string
  default = "es"
}

variable "custom_root_id" {
  type    = string
  default = "main" #This name needs to match the root id name in the module custom LZ config
}

variable "root_name" { #OPTIONAL: If specified, will set a custom DisplayName value for the Enterprise-scale "root" Management Group.
  type    = string
  default = "ESLZ Root"
}

variable "deploy_management_resources" {
  type        = bool
  description = "If set to true, will deploy the \"Management\" landing zone resources into the current Subscription context."
  default     = false
}

variable "configure_management_resources" {
  type = object({
    settings = object({
      log_analytics = object({
        enabled = bool
        config = object({
          retention_in_days                           = number
          enable_monitoring_for_arc                   = bool
          enable_monitoring_for_vm                    = bool
          enable_monitoring_for_vmss                  = bool
          enable_solution_for_agent_health_assessment = bool
          enable_solution_for_anti_malware            = bool
          enable_solution_for_azure_activity          = bool
          enable_solution_for_change_tracking         = bool
          enable_solution_for_service_map             = bool
          enable_solution_for_sql_assessment          = bool
          enable_solution_for_updates                 = bool
          enable_solution_for_vm_insights             = bool
          enable_sentinel                             = bool
        })
      })
      security_center = object({
        enabled = bool
        config = object({
          email_security_contact             = string
          enable_defender_for_acr            = bool
          enable_defender_for_app_services   = bool
          enable_defender_for_arm            = bool
          enable_defender_for_dns            = bool
          enable_defender_for_key_vault      = bool
          enable_defender_for_kubernetes     = bool
          enable_defender_for_servers        = bool
          enable_defender_for_sql_servers    = bool
          enable_defender_for_sql_server_vms = bool
          enable_defender_for_storage        = bool
        })
      })
    })
    location = any
    tags     = any
    advanced = any
  })
  description = "If specified, will customize the \"Management\" landing zone resources."
  default = {
    settings = {
      log_analytics = {
        enabled = true
        config = {
          retention_in_days                           = 30
          enable_monitoring_for_arc                   = true
          enable_monitoring_for_vm                    = true
          enable_monitoring_for_vmss                  = true
          enable_solution_for_agent_health_assessment = true
          enable_solution_for_anti_malware            = true
          enable_solution_for_azure_activity          = true
          enable_solution_for_change_tracking         = true
          enable_solution_for_service_map             = true
          enable_solution_for_sql_assessment          = true
          enable_solution_for_updates                 = true
          enable_solution_for_vm_insights             = true
          enable_sentinel                             = true
        }
      }
      security_center = {
        enabled = true
        config = {
          email_security_contact             = "security_contact@replace_me"
          enable_defender_for_acr            = true
          enable_defender_for_app_services   = true
          enable_defender_for_arm            = true
          enable_defender_for_dns            = true
          enable_defender_for_key_vault      = true
          enable_defender_for_kubernetes     = true
          enable_defender_for_servers        = true
          enable_defender_for_sql_servers    = true
          enable_defender_for_sql_server_vms = true
          enable_defender_for_storage        = true
        }
      }
    }
    location = null
    tags     = null
    advanced = null
  }
}

variable "subscription_id_connectivity" {
  type        = string
  description = "If specified, identifies the Platform subscription for \"Connectivity\" for resource deployment and correct placement in the Management Group hierarchy."
  default     = ""

  validation {
    condition     = can(regex("^[a-z0-9-]{36}$", var.subscription_id_connectivity)) || var.subscription_id_connectivity == ""
    error_message = "Value must be a valid Subscription ID (GUID)."
  }
}

variable "subscription_id_identity" {
  type        = string
  description = "If specified, identifies the Platform subscription for \"Identity\" for resource deployment and correct placement in the Management Group hierarchy."
  default     = ""

  validation {
    condition     = can(regex("^[a-z0-9-]{36}$", var.subscription_id_identity)) || var.subscription_id_identity == ""
    error_message = "Value must be a valid Subscription ID (GUID)."
  }
}

variable "custom_subscription_id_management" {
  type        = string
  description = "If specified, identifies the Platform subscription for \"Management\" for resource deployment and correct placement in the Management Group hierarchy."
  default     = ""

  validation {
    condition     = can(regex("^[a-z0-9-]{36}$", var.custom_subscription_id_management)) || var.custom_subscription_id_management == ""
    error_message = "Value must be a valid Subscription ID (GUID)."
  }
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

variable "custom_root_id_custom_landing_zones" { #OPTIONAL: If specified, will deploy additional Management Groups alongside Enterprise-scale core Management Groups.
  type    = map(object({ display_name = string, parent_management_group_id = string, subscription_ids = list(string), archetype_config = object({ archetype_id = string, parameters = any, access_control = any }) }))
  default = {}
}

variable "default_location" { #OPTIONAL: If specified, will use set the default location used for resource deployments where needed.
  type    = string
  default = "eastus"
}

variable "deploy_core_landing_zones" { #OPTIONAL: If set to true, will include the core Enterprise-scale Management Group hierarchy.
  type    = bool
  default = true
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

variable "custom_policy_roles" {
  type        = map(list(string))
  description = "If specified, the custom_policy_roles variable overrides which Role Definition ID(s) (value) to assign for Policy Assignments with a Managed Identity, if the assigned \"policyDefinitionId\" (key) is included in this variable."
  default     = {}
}
