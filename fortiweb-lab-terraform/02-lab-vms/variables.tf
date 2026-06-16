variable "resource_group_name" { type = string }
variable "vnet_name" { type = string }
variable "guac_image_id" { type = string }
variable "docker1_image_id" { type = string }
variable "docker2_image_id" { type = string }
variable "guac_size" { type = string, default = "Standard_D2s_v3" }
variable "docker_size" { type = string, default = "Standard_D2s_v3" }
