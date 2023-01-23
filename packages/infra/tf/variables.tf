variable "region" {
  type = string
}

variable "certificate_arn" {
  type = string
}

variable "vpc_cidirblock" {
  type = string
}

variable "profile" {
  type    = string
  default = "atos-ams"
}

variable "environment" {
  type = string
}

variable "account_no" {
  description = "AWS account number"
  type        = number
}

# Route53 variables

variable "r53_host" {
  description = "DNS name for ALB"
  type        = string
}

variable "r53_zone_net" {
  description = "Holds zone net name for r53"
  type        = string
}

variable "default_tags" {
  type = map(string)
}