
output "Domain" {
  value = "${var.r53_host}.${var.r53_zone_net}"

}