data "aws_availability_zones" "available" {}


resource "aws_vpc" "code-corpus-api" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "code-corpus-api"
  }
}

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.code-corpus-api.id
  tags = {
    Name = "code-corpus-api-ig"
    Environment = "code-corpus"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.code-corpus-api.id
  tags = {
    Name = "code-corpus-public-route-table"
  }
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ig.id
}

#resource "aws_route_table_association" "public" {
#  subnet_id      = aws_subnet.public_subnet[count.index].id
#  route_table_id = aws_route_table.public[count.index].id
#}

resource "aws_subnet" "public_subnet" {
  count  = length(data.aws_availability_zones.available.names)

  vpc_id = aws_vpc.code-corpus-api.id
  cidr_block = "10.0.${10 + count.index}.0/24"

  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-code-corpus-subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.code-corpus-api.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "private-code-corpus-subnet"
  }
}

# just a place-holder until I can decide on something more permanent
#resource "aws_route53_zone" "main" {
#  name = "codecorpus.net"
#}
