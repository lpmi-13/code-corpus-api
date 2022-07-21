variable "region" {
  description = "AWS deployment region"
  default     = "eu-west-1"
}

variable "db_username" {
  description = "the username for our database"
  default     = "CHANGE_ME"
}

variable "db_password" {
  description = "the master password for the rds instance"
  default     = "CHANGE_ME"
}

variable "public_ip" {
  description = "the public IP to allow access into the bastion host"
  default     = "PUBLIC_IP_TO_CHANGE"
}
