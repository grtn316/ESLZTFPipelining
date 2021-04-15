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

provider "azurerm" {
#  subscription_id = var.subscription_id
#  tenant_id       = var.tenant_id
  features {}
}


data "azurerm_billing_enrollment_account_scope" "example" {
  billing_account_name    = "david.a.baumgarten@gmail.com"
  enrollment_account_name = "david.a.baumgarten@gmail.com"
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