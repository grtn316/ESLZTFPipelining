# Base Variables 

# variable "tenant_id" {

# }

# variable "subscription_id" {

# }

# variable "location" {
# }

variable "tags" {
   type        = map(string)

  default = {
    owner = "jcroth"
    project = "testing"
  }
}
