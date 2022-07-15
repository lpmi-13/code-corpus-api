resource "aws_lb" "code-corpus-alb" {
  name               = "code-corpus-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.load-balancer.id]
  #subnets            = [for subnet in aws_subnet.public_subnet : subnet.id]
  subnets            = aws_subnet.public_subnet.*.id

  enable_deletion_protection = false

  tags = {
    Environment = "code-corpus-api"
  }
}

resource "aws_db_instance" "api-datastore" {
  allocated_storage    = 20
  allow_major_version_upgrade = false
  engine               = "postgresql"
  engine_version       = "14"
  instance_class       = "db.t4g.micro"
  db_name              = "api-datastore"
  username             = "CHANGE_ME"
  password             = "CHANGE_ME"
  skip_final_snapshot  = true
}