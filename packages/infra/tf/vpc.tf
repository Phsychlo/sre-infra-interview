# Create VPC
resource "aws_vpc" "some_custom_vpc" {
  cidr_block = var.vpc_cidirblock
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(
    tomap({ "Name" = "Some Custom VPC" }),
    var.default_tags
  )
}

# Attach an Internet Gateway to VPC
resource "aws_internet_gateway" "some_ig" {
  vpc_id = aws_vpc.some_custom_vpc.id
  # subnet_id = 
  tags = merge(
    tomap({ "Name" = "Some Internet Gateway" }),
    var.default_tags
  )
}

# Create VPC endpoints for SSM access from private EC2
## ssm VPC endpoint
resource "aws_vpc_endpoint" "ssm_vpc_ep" {
  vpc_id            = aws_vpc.some_custom_vpc.id
  service_name      = "com.amazonaws.eu-west-2.ssm"
  vpc_endpoint_type = "Interface"
  subnet_ids = [ aws_subnet.some_private_subnet.id, aws_subnet.some_private_subnet2.id ]
  ip_address_type = "ipv4"

  security_group_ids = [
    aws_security_group.alb-sg.id,
  ]

  tags = merge(
    tomap({ "Name" : "Kanye-endpoint-ssm" }),
    var.default_tags
  )

  private_dns_enabled = true
}

## ec2 VPC endpoint
resource "aws_vpc_endpoint" "ec2_vpc_ep" {
  vpc_id            = aws_vpc.some_custom_vpc.id
  service_name      = "com.amazonaws.eu-west-2.ec2"
  vpc_endpoint_type = "Interface"
  subnet_ids = [ aws_subnet.some_private_subnet.id, aws_subnet.some_private_subnet2.id ]
  ip_address_type = "ipv4"

  security_group_ids = [
    aws_security_group.alb-sg.id,
  ]

  tags = merge(
    tomap({ "Name" : "Kanye-endpoint-ec2" }),
    var.default_tags
  )

  private_dns_enabled = true
}

## ec2messages VPC endpoint
resource "aws_vpc_endpoint" "ec2msgs_vpc_ep" {
  vpc_id            = aws_vpc.some_custom_vpc.id
  service_name      = "com.amazonaws.eu-west-2.ec2messages"
  vpc_endpoint_type = "Interface"
  subnet_ids = [ aws_subnet.some_private_subnet.id, aws_subnet.some_private_subnet2.id ]
  ip_address_type = "ipv4"


  security_group_ids = [
    aws_security_group.alb-sg.id,
  ]

  tags = merge(
    tomap({ "Name" : "Kanye-endpoint-ec2msgs" }),
    var.default_tags
  )

  private_dns_enabled = true
}

## ssmmessages VPC endpoint
resource "aws_vpc_endpoint" "ssmmsgs_vpc_ep" {
  vpc_id            = aws_vpc.some_custom_vpc.id
  service_name      = "com.amazonaws.eu-west-2.ssmmessages"
  vpc_endpoint_type = "Interface"
  subnet_ids = [ aws_subnet.some_private_subnet.id, aws_subnet.some_private_subnet2.id ]
  ip_address_type = "ipv4"

  security_group_ids = [
    aws_security_group.alb-sg.id,
  ]

  tags = merge(
    tomap({ "Name" : "Kanye-endpoint-ssmmsgs" }),
    var.default_tags
  )

  private_dns_enabled = true
}

## kms VPC endpoint
resource "aws_vpc_endpoint" "kms_vpc_ep" {
  vpc_id            = aws_vpc.some_custom_vpc.id
  service_name      = "com.amazonaws.eu-west-2.kms"
  vpc_endpoint_type = "Interface"
  subnet_ids = [ aws_subnet.some_private_subnet.id, aws_subnet.some_private_subnet2.id ]
  ip_address_type = "ipv4"

  security_group_ids = [
    aws_security_group.alb-sg.id,
  ]

  tags = merge(
    tomap({ "Name" : "Kanye-endpoint-kms" }),
    var.default_tags
  )

  private_dns_enabled = true
}