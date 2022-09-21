data "aws_availability_zones" "available" {}


resource "aws_vpc" "code-corpus-api" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "code-corpus-api"
  }
}

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.code-corpus-api.id
  tags = {
    Name        = "code-corpus-api-ig"
    Environment = "code-corpus"
  }
}

// this is what lets us hit the bastion server
resource "aws_route_table_association" "bastion-route-table" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_main_route_table_association" "internet-ingress" {
  vpc_id = aws_vpc.code-corpus-api.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.code-corpus-api.id

  route {
    cidr_block =  "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }

  tags = {
    Name = "code-corpus-public-route-table"
  }
}

resource "aws_subnet" "public_subnet_a" {
  vpc_id     = aws_vpc.code-corpus-api.id
  cidr_block = "10.0.10.0/24"

  availability_zone       = "eu-west-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-code-corpus-subnet"
  }
}

resource "aws_subnet" "public_subnet_b" {

  vpc_id     = aws_vpc.code-corpus-api.id
  cidr_block = "10.0.11.0/24"

  availability_zone       = "eu-west-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-code-corpus-subnet"
  }
}

resource "aws_subnet" "public_subnet_c" {

  vpc_id     = aws_vpc.code-corpus-api.id
  cidr_block = "10.0.12.0/24"

  availability_zone       = "eu-west-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-code-corpus-subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  count = length(data.aws_availability_zones.available.names)

  vpc_id            = aws_vpc.code-corpus-api.id
  cidr_block        = "10.0.${20 + count.index}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "private-code-corpus-subnet"
  }
}

resource "aws_db_subnet_group" "db_subnet" {
  name       = "db_subnet"
  subnet_ids = aws_subnet.private_subnet.*.id

  tags = {
    Name = "api_db_subnet"
  }
}

// this will probably end up being a subdomain like
// api.codecorpus.net
resource "aws_route53_record" "www" {
  zone_id = var.hosted_zone_id
  name    = var.domain_for_certificate
  type    = "A"
  allow_overwrite = true

  alias {
    name                   = aws_lb.code-corpus-alb.dns_name
    zone_id                = aws_lb.code-corpus-alb.zone_id
    evaluate_target_health = false
  }

  provider = aws
}

// this second record is what makes it validate correctly
resource "aws_route53_record" "cert_validation" {
  allow_overwrite = true
  name            = tolist(aws_acm_certificate.code-corpus-cert.domain_validation_options)[0].resource_record_name
  records         = [ tolist(aws_acm_certificate.code-corpus-cert.domain_validation_options)[0].resource_record_value ]
  type            = tolist(aws_acm_certificate.code-corpus-cert.domain_validation_options)[0].resource_record_type
  zone_id  = var.hosted_zone_id
  ttl      = 30
  provider = aws
}

resource "aws_acm_certificate" "code-corpus-cert" {
  domain_name       = aws_route53_record.www.fqdn
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "certificate for ${var.domain_for_certificate}"
  }
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn = aws_acm_certificate.code-corpus-cert.arn
  validation_record_fqdns = [ aws_route53_record.cert_validation.fqdn ]
}