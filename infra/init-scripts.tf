resource "null_resource" "bastion_setup" {

  depends_on = [
    aws_instance.bastion-host,
    aws_db_instance.api-datastore,
    aws_route_table.public
  ]

  // first we copy the sql script to the bastion so we can run it
  // from there after we set up the psql command line utility
  provisioner "local-exec" {
    command = <<EOF
      scp -i terraform.ed25519 \
      -o StrictHostKeyChecking=no \
      -o UserKnownHostsFile=/dev/null \
      ../app/sql/create_database.sql ubuntu@"$BASTION_IP":~/ && \
      ssh -i terraform.ed25519 \
      -o StrictHostKeyChecking=no \
      -o UserKnownHostsFile=/dev/null \
      ubuntu@"$BASTION_IP" -C \
        "sudo apt update -y && \
        sudo apt install postgresql postgresql-contrib -y && \
      PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -U $DB_USER -d postgres -f ~/create_database.sql"
    EOF 
    environment = {
      BASTION_IP = aws_instance.bastion-host.public_ip
      DB_HOST = aws_db_instance.api-datastore.address
      DB_PASSWORD = random_password.password.result
      DB_USER = var.db_username
    }
    interpreter = ["bash", "-c"]
  }
}

resource "null_resource" "data_loading" {
  depends_on = [
    aws_db_instance.api-datastore,
    aws_ecs_service.code-corpus-api
  ]

  // after the database is set up and the service has connected,
  // we can load in the data and create the materialized view
  provisioner "local-exec" {
    command = <<EOF
      scp -i terraform.ed25519 \
      -o StrictHostKeyChecking=no \
      -o UserKnownHostsFile=/dev/null \
      ../app/inject.py \
      ../app/test-data/{javascript,typescript,python,golang}.json \
      ../app/sql/create_materialized_view.sql ubuntu@"$BASTION_IP":~/ && \
      ssh -i terraform.ed25519 \
      -o StrictHostKeyChecking=no \
      -o UserKnownHostsFile=/dev/null \
      ubuntu@"$BASTION_IP" -C \
        "sudo apt install -y libpq-dev python3-dev build-essential && \
        sudo mkdir -p /tmp/psycopg2 && cd /tmp/psycopg2 && \
        sudo git clone https://github.com/psycopg/psycopg2 && \
        cd psycopg2 && sudo python3 setup.py build && sudo python3 setup.py install && \
        cd ~ && \
        PASSWORD=$DB_PASSWORD HOST=$DB_HOST USERNAME=$DB_USER DATABASE=$DATABASE python3 inject.py && \
        PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -U $DB_USER -d $DATABASE -f ~/create_materialized_view.sql"
    EOF 
    environment = {
      BASTION_IP = aws_instance.bastion-host.public_ip
      DB_HOST = aws_db_instance.api-datastore.address
      DB_PASSWORD = var.functions_db_password
      DB_USER = var.functions_db_username
      DATABASE = var.functions_db_database
    }
    interpreter = ["bash", "-c"]
  }
}
