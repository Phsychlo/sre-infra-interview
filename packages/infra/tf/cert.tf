resource "aws_acm_certificate" "alb_cert" {
  domain_name       = "${var.r53_host}.${var.r53_zone_net}"
  validation_method = "DNS"
}

resource "aws_route53_record" "alb_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.alb_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.public_net.zone_id

}

resource "aws_acm_certificate_validation" "alb_cert" {
  certificate_arn = aws_acm_certificate.alb_cert.arn
  validation_record_fqdns = [
    for record in aws_route53_record.alb_cert_validation : record.fqdn
  ]
}

# Route53 terraform
data "aws_route53_zone" "public_net" {
  name         = var.r53_zone_net
  private_zone = false
}

resource "aws_route53_record" "ec2test2" {
  zone_id = data.aws_route53_zone.public_net.zone_id
  name    = "${var.r53_host}.${var.r53_zone_net}"
  type    = "CNAME"
  ttl     = "60"
  records = [aws_lb.app_loadbalancer.dns_name]
  depends_on = [
    aws_lb.app_loadbalancer
  ]
}