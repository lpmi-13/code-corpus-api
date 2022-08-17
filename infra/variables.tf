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

variable "ecr_repo_url" {
  description = "the URL of the ECR repo, so we don't need to create one via terraform"
  default = "aws_account_id.dkr.ecr.region.amazonaws.com"
}

// adding this because I don't want the route53 record in terraform state
variable "hosted_zone_id" {
  description = "the ID of the hosted zone"
  default = "ABC123"
}
