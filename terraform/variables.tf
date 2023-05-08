variable "project" {
  type        = string
  description = "Project name"
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "Environment type"
}

variable "author" {
  type        = string
  default     = "None"
  description = "Author"
}

variable "bastion_key" {
  type        = string
  default     = null
  description = "Bastion public key"

  validation {
    condition     = startswith(var.bastion_key, "ssh-rsa ")
    error_message = "Bastion key needs to be public key in OpenSSH format."
  }
}
