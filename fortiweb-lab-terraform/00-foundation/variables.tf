variable "resource_group_name" {
  type        = string
  description = "Pre-created student resource group (provisioned outside this project)."
}
variable "vnet_name" { type = string }
variable "student_source_cidr" { type = string }
