variable "common_tags" {
  description = "Common Tags to apply to all resources"
  type        = map(any)
  default = {
    Owner       = "Sahib Gasimov"
    Project     = "Phoenix"
    CostCenter  = "12345"
    Environment = "development"
  }
}



variable "allow_ports" {
  description = "List of Ports to open for server"
  type        = list(any)
  default     = ["22"]
}

variable "public_key" {
  type        = string
  description = "Please provide your public_key"
  default     = "~/.ssh/ec2_id_rsa.pub"
}


variable "launch_template_version" {
  default = ""
}