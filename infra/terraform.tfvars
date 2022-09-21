region      = "eu-west-1"
db_username = "CHANGE_ME"

# this is set by running the ./set_public_ip.sh script
public_ip = ""

ecr_repo_url = "123456789012.dkr.ecr.region.amazonaws.com/code-corpus-api"
hosted_zone_id = "LONGBUNCHOFDIGITS"
db_connection_string = "host=ENDPOINT_OF_THE_RDS_INSTANCE user=USER_GOES_HERE password=CHANGE_ME dbname=code port=5432"
domain_for_certificate = "DOMAIN.COM"

# these are for the connections to the functions database
functions_db_username = "USERNAME"
functions_db_database = "code"
functions_db_password = "CHANGE_ME"
