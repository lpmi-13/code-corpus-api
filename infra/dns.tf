
# We intentionally keep the apex domain out of terraform, just to avoid
# accidentally destroying it.

# Hosted Zone for the api subdomain
resource "aws_route53_zone" "zone_api" {
  name    = "api.${var.apex_domain_for_certificate}"
  comment = "Hosted Zone for api.${var.apex_domain_for_certificate}"

  tags = {
    Name   = "api.${var.apex_domain_for_certificate}"
    Origin = "terraform"
  }
}

# Record in the apex hosted zone that contains the name servers of the api subdomain hosted zone
resource "aws_route53_record" "ns_record_api" {
  depends_on = [
    aws_route53_zone.zone_api
  ]
  type    = "NS"
  zone_id = var.apex_hosted_zone_id
  name    = "api"
  ttl     = "86400"
  records = [
    aws_route53_zone.zone_api.name_servers[0],
    aws_route53_zone.zone_api.name_servers[1],
    aws_route53_zone.zone_api.name_servers[2],
    aws_route53_zone.zone_api.name_servers[3],
  ]
}


// this is the record pointing from the api subdomain to the load balancer
resource "aws_route53_record" "api" {
  zone_id         = aws_route53_zone.zone_api.zone_id
  name            = "api.${var.apex_domain_for_certificate}"
  type            = "A"
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
  records         = [tolist(aws_acm_certificate.code-corpus-cert.domain_validation_options)[0].resource_record_value]
  type            = tolist(aws_acm_certificate.code-corpus-cert.domain_validation_options)[0].resource_record_type
  zone_id         = aws_route53_zone.zone_api.zone_id
  ttl             = 30
  provider        = aws
}

resource "aws_acm_certificate" "code-corpus-cert" {
  domain_name       = aws_route53_record.api.fqdn
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "certificate for api.${var.apex_domain_for_certificate}"
  }
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.code-corpus-cert.arn
  validation_record_fqdns = [aws_route53_record.cert_validation.fqdn]
}
