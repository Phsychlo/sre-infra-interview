# Create subnets for different parts of the infrastructure 
resource "aws_subnet" "some_public_subnet" {
  vpc_id            = aws_vpc.some_custom_vpc.id
  cidr_block        = "10.1.0.0/24"
  availability_zone = "eu-west-2a"
  tags = merge(
    tomap({ "Name" : "Some Public Subnet" }),
    var.default_tags
  )
}

resource "aws_subnet" "some_public_subnet2" {
  vpc_id            = aws_vpc.some_custom_vpc.id
  cidr_block        = "10.1.3.0/24"
  availability_zone = "eu-west-2b"

  tags = merge(
    tomap({ "Name" : "Some Public Subnet2" }),
    var.default_tags
  )
}

resource "aws_subnet" "some_private_subnet" {
  vpc_id            = aws_vpc.some_custom_vpc.id
  cidr_block        = "10.1.2.0/24"
  availability_zone = "eu-west-2b"

  tags = merge(
    tomap({ "Name" : "Some Private Subnet" }),
    var.default_tags
  )

}
resource "aws_subnet" "some_private_subnet2" {
  vpc_id            = aws_vpc.some_custom_vpc.id
  cidr_block        = "10.1.4.0/24"
  availability_zone = "eu-west-2a"
  tags = merge(
    tomap({ "Name" : "Some Private Subnet2" }),
    var.default_tags
  )
}