# Create a route table for a public subnet
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.some_custom_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.some_ig.id
  }

  tags = {
    Name = "Public Route Table"
  }
}

# Associate route table with public subnets 
resource "aws_route_table_association" "public_1_rt_a" {
  subnet_id      = aws_subnet.some_public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_1_rt_b" {
  subnet_id      = aws_subnet.some_public_subnet2.id
  route_table_id = aws_route_table.public_rt.id
}

# Create a route table
resource "aws_route_table" "nat_gateway" {
  vpc_id = aws_vpc.some_custom_vpc.id
  
  tags = {
    Name = "Private Route Table"
  }
}

# Associate route table with private subnet 02
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.some_private_subnet2.id
  route_table_id = aws_route_table.nat_gateway.id
}

# Associate route table with private subnet 01
resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.some_private_subnet.id
  route_table_id = aws_route_table.nat_gateway.id
}