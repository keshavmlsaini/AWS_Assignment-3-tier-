resource "aws_vpc" "my_vpc" { #vpc
  cidr_block           = "10.10.0.0/21"
  enable_dns_hostnames = true

  tags = {
    Name = "My VPC"
  }
}

# subnets
resource "aws_subnet" "public_us_east_2a" { #subnet 1 
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.10.0.0/23"
  availability_zone = "us-east-2a"

  tags = {
    Name = "Public Subnet us-east-2a"
  }
}

resource "aws_subnet" "public_us_east_2b" { #subnet 2
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.10.2.0/23"
  availability_zone = "us-east-2b"

  tags = {
    Name = "Public Subnet us-east-2b"
  }
}

resource "aws_subnet" "private_us_east_2a" { #subnet 3
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.10.4.0/23"
  availability_zone = "us-east-2a"

  tags = {
    Name = "Private us-east-2a"
  }
}

resource "aws_subnet" "private_us_east_2b" { #subnet 4
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.10.6.0/23"
  availability_zone = "us-east-2b"

  tags = {
    Name = "Private us-east-2b"
  }
}

resource "aws_internet_gateway" "my_vpc_igw" { # igw
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "My VPC - Internet Gateway"
  }
}
# RT for public 
resource "aws_route_table" "my_vpc_public" {
  vpc_id = aws_vpc.my_vpc.id #public 

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_vpc_igw.id
  }

  tags = {
    Name = "Public Subnets Route Table for My VPC"
  }
}

resource "aws_route_table_association" "my_vpc_us_east_2a_public" {
  subnet_id      = aws_subnet.public_us_east_2a.id
  route_table_id = aws_route_table.my_vpc_public.id
}

resource "aws_route_table_association" "my_vpc_us_east_2b_public" {
  subnet_id      = aws_subnet.public_us_east_2b.id
  route_table_id = aws_route_table.my_vpc_public.id
}


# Nat (elastic ip  )

resource "aws_eip" "nat_eip" {
  vpc = true
  #depends_on = [aws_internet_gateway.id]
}


# NAT GW
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_us_east_2a.id
  tags = {
    Name = "3-tier-nat"
  }
}

# RT Private
resource "aws_route_table" "my_vpc_private" {
  vpc_id = aws_vpc.my_vpc.id #private

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "private Subnets Rt for My VPC"
  }
}




# RT Association

resource "aws_route_table_association" "my_vpc_us_east_2a_private" {
  subnet_id      = aws_subnet.private_us_east_2a.id
  route_table_id = aws_route_table.my_vpc_private.id
}

resource "aws_route_table_association" "my_vpc_us_east_2b_private" {
  subnet_id      = aws_subnet.private_us_east_2b.id
  route_table_id = aws_route_table.my_vpc_public.id
}
