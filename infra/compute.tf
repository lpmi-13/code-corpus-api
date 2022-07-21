resource "aws_lb" "code-corpus-alb" {
  name               = "code-corpus-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.load-balancer.id]
  subnets = [
    aws_subnet.public_subnet_a.id,
    aws_subnet.public_subnet_b.id,
    aws_subnet.public_subnet_c.id
  ]

  enable_deletion_protection = false

  tags = {
    Environment = "code-corpus-api"
  }
}

resource "aws_db_instance" "api-datastore" {
  allocated_storage           = 20
  allow_major_version_upgrade = false
  engine                      = "postgres"
  engine_version              = "14"
  instance_class              = "db.t4g.micro"
  storage_type                = "gp2"
  storage_encrypted           = true
  identifier                  = "api-datastore"
  db_subnet_group_name        = aws_db_subnet_group.db_subnet.name
  username                    = var.db_username
  password                    = var.db_password
  vpc_security_group_ids      = [aws_security_group.rds-instance.id]
  # when you're ready to go to production, uncomment this
  # deletion_protection         = true
  skip_final_snapshot         = true
}

resource "aws_network_interface" "bastion-interface" {
  subnet_id       = aws_subnet.public_subnet_a.id
  security_groups = [aws_security_group.bastion-host.id]

  # so we can tunnel the ssh connection
  source_dest_check = false
}

resource "aws_key_pair" "bastion-keys" {
  key_name   = "bastion-keys"
  public_key = file("./terraform.ed25519.pub")
}

# this is the bastion host to connect to the database and seed the data
resource "aws_instance" "bastion-host" {
  ami               = "ami-079e64f0f92b31250"
  instance_type     = "t4g.nano"
  key_name          = aws_key_pair.bastion-keys.key_name
  availability_zone = "eu-west-1a"

  network_interface {
    network_interface_id = aws_network_interface.bastion-interface.id
    device_index         = 0
  }

  tags = {
    "Name" = "bastion host"
  }
}
