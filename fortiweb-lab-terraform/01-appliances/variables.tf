variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "vnet_name" { type = string }
variable "admin_username" { type = string }
variable "admin_password" { type = string, sensitive = true }
variable "fortigate_size" { type = string, default = "Standard_F2s_v2" }
variable "fortiweb_size" { type = string, default = "Standard_F2s_v2" }
variable "fortiweb_data_disk_gb" { type = number, default = 30 }

variable "fortigate_publisher" { type = string, default = "fortinet" }
variable "fortigate_offer" { type = string, default = "fortinet_fortigate-vm_v5" }
variable "fortigate_sku" { type = string, default = "fortinet_fg-vm_payg_20190624" }
variable "fortigate_version" { type = string, default = "latest" }
variable "fortigate_bootstrap_config" {
  type        = string
  default     = "../configs/fortigate-bootstrap.conf.tpl"
  description = "MIME cloud-init template applied to FortiGate at first boot."
}
variable "fortigate_lab_student_password" {
  type        = string
  sensitive   = true
  description = "FortiOS/FortiWeb password for the lab-student admin account."
}

variable "fortiweb_bootstrap_config" {
  type        = string
  default     = "../configs/fortiweb-bootstrap.conf.tpl"
  description = "MIME cloud-init template applied to FortiWeb at first boot."
}

variable "fortiweb_publisher" { type = string, default = "fortinet" }
variable "fortiweb_offer" { type = string, default = "fortinet_fortiweb-vm_v2" }
variable "fortiweb_sku" { type = string, default = "fortinet_fw-vm_payg" }
variable "fortiweb_version" { type = string, default = "latest" }
