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

variable "bastion_key_filename" {
  type        = string
  description = "Bastion public key filename"

  validation {
    condition     = startswith(file(var.bastion_key_filename), "ssh-rsa ")
    error_message = "Bastion key needs to be public key in OpenSSH format."
  }
}