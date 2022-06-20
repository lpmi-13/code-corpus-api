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
