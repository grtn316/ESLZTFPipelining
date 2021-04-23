terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.46.1"
    }
    random = {
      version = ">=3.0"
    }
  }

#   backend "remote" {
#     hostname = "app.terraform.io"
#     organization = "jcroth"
#     workspaces {
#       name = "netops"
#     }
#   }
}

# provider "azurerm" {
# #  subscription_id = var.subscription_id
# #  tenant_id       = var.tenant_id
#   features {}
# }

provider "azurerm" {
  subscription_id = "297561b8-e4ce-47cd-90a4-76be4812f825"  
  tenant_id       = "3fc1081d-6105-4e19-b60c-1ec1252cf560"
  # tenant_id = "2f4a9838-26b7-47ee-be60-ccc1fdec5953"
  client_id       = "3b01c46a-1736-49a3-bf83-228c8614fc37"
  client_secret   = "4Wz55P12_OG54ZzLTcdEwNbPk9liz2vzev"
 # auxiliary_tenant_ids = ["2f4a9838-26b7-47ee-be60-ccc1fdec5953"]
  features {}
}


data "azurerm_billing_enrollment_account_scope" "example" {
  billing_account_name    = "8608480"
  enrollment_account_name = "CSU"
}


resource "azurerm_subscription" "example" {
  subscription_name = "Landing Zone A2"
  billing_scope_id  = data.azurerm_billing_enrollment_account_scope.example.id
}

# output "billing_account_name" {
#     value = data.azurerm_billing_enrollment_account_scope.example.name
# }

output "id" {
  value = data.azurerm_billing_enrollment_account_scope.example.id
}


# resource "azurerm_subscription" "example" {
#   subscription_name = "My Example EA Subscription"
#   billing_scope_id  = data.azurerm_billing_enrollment_account_scope.example.id
# }