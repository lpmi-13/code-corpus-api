variable "region" {
  description = "AWS deployment region"
  default     = "eu-west-1"
}

variable "db_username" {
  description = "the username for our database"
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

variable "log_group_name" {
  description = "the log group for the application"
  default = "awslogs-code-corpus-api"
}

variable "db_connection_string" {
  description = "the database connection string"
  default = "THIS_DEFAULT_WON'T_WORK"
}

variable "domain_for_certificate" {
  description = "this is the domain you want the api to respond to"
}

variable "functions_db_username" {
  description = "the username for the functions database"
  default = "CHANGE_ME"
}

variable "functions_db_password" {
  description = "the password for the functions database"
  default = "CHANGE_ME"
}

variable "functions_db_database" {
  description = "the name of the database holding the functions data"
  default = "code"
}