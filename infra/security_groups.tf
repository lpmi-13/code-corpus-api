resource "aws_security_group" "load-balancer" {
  name        = "code-corpus-sg"
  description = "Default security group to allow inbound/outbound from the VPC"
  vpc_id      = aws_vpc.code-corpus-api.id
  depends_on  = [aws_vpc.code-corpus-api]
  ingress = [
    {
      description      = "let requests hit the load balancer"
      from_port        = "443"
      to_port          = "443"
      protocol         = "tcp"
      security_groups  = []
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = null
      prefix_list_ids  = []
      self             = "true"
    }
  ]


  egress = [
    {
      description      = "let us free!"
      from_port        = "0"
      to_port          = "0"
      protocol         = "-1"
      security_groups  = []
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      self             = "true"
    }
  ]

  tags = {
    Name        = "allow_access"
    Environment = "code-corpus-api"
  }
}

resource "aws_security_group" "bastion-host" {
  name        = "code-corpus-bastion"
  description = "allows SSH access to the bastion host from one IP"
  vpc_id      = aws_vpc.code-corpus-api.id
  depends_on  = [aws_vpc.code-corpus-api]
  ingress = [
    {
      description      = "let requests hit the load balancer"
      from_port        = "22"
      to_port          = "22"
      protocol         = "tcp"
      security_groups  = []
      # make sure you run the ./set_public_ip.sh script or this won't resolve
      cidr_blocks      = ["${var.public_ip}/32"]
      ipv6_cidr_blocks = null
      prefix_list_ids  = []
      self             = "true"
    }
  ]

  tags = {
    Name        = "bastion-access"
    Environment = "code-corpus-api"
  }
}