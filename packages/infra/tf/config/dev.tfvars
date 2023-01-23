environment     = "dev"
region          = "eu-west-2"
vpc_cidirblock  = "10.1.0.0/16"
certificate_arn = "arn:aws:acm:eu-west-2:188556555096:certificate/daa96292-afc7-4c8a-995d-ce1007d59b34"

account_no = 188556555096

# Route53
r53_host     = "ec2test"
r53_zone_net = "atos-cerebro.net"

default_tags = {
  project : "jnr-interview",
  createdBy : "terraform",
  team : "atoscerebro",
  environment : "dev"
}