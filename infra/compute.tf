resource "aws_lb" "code-corpus-alb" {
  name               = "code-corpus-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.load-balancer.id]
  subnets = aws_subnet.public_subnet.*.id

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
  skip_final_snapshot         = true
}