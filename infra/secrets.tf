
# the secret string stuff is all currently hardcoded, so a TODO is to get that working

# resource "aws_secretsmanager_secret" "db_connection_string" {
  # name = "DatabaseConnection"
  # // setting this to zero to make it easy to re-apply terrform updates
  # recovery_window_in_days = 0
# }
# 
# resource "aws_secretsmanager_secret_version" "db_connection_string" {
  # secret_id     = aws_secretsmanager_secret.db_connection_string.id
  # secret_string = var.db_connection_string
# }
# 
# resource "aws_secretsmanager_secret" "master_db_connection" {
  # name = "MasterDBConnection"
  # // setting this to zero to make it easy to re-apply terrform updates
  # recovery_window_in_days = 0
# }
# 
# resource "aws_secretsmanager_secret_version" "master_db_connection" {
  # secret_id     = aws_secretsmanager_secret.master_db_connection.id
  # secret_string = jsonencode({
    # engine: "postgres",
    # host: aws_db_instance.api-datastore.address,
    # username: var.db_username,
    # password: var.db_password
  # })
# }
# 

// these are for the postgres master user, which we only need
// to run the script to set up the code database initially
resource "random_password" "password" {
  length           = 20
  special = false
}
