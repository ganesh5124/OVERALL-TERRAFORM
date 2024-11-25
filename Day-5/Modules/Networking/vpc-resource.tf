
# VPC Creation
resource "aws_vpc" "devops-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    name = var.vpc_name
  }
}

# Internet Gateway
resource "aws_internet_gateway" "devops-igw" {
  vpc_id     = aws_vpc.devops-vpc.id
  depends_on = [aws_vpc.devops-vpc]
  tags = {
    Name = var.igw_name
  }
}

# Route table
resource "aws_route_table" "devops-rt" {
  vpc_id     = aws_vpc.devops-vpc.id
  depends_on = [aws_internet_gateway.devops-igw, aws_vpc.devops-vpc, ]
  route {
    cidr_block = var.allow_all_route
    gateway_id = aws_internet_gateway.devops-igw.id
  }
  tags = {
    Name = var.rt_name
  }
}

# Subnet creation
resource "aws_subnet" "devops-subnet" {
  depends_on              = [aws_vpc.devops-vpc, aws_route_table.devops-rt]
  vpc_id                  = aws_vpc.devops-vpc.id
  cidr_block              = var.vpc_cidr_block
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true
  tags = {
    Name = var.subnet_name
  }
}

# Subnet creation
resource "aws_subnet" "devops-subnet-private" {
  depends_on              = [aws_vpc.devops-vpc, aws_route_table.devops-rt]
  vpc_id                  = aws_vpc.devops-vpc.id
  cidr_block              = var.vpc_cidr_block
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true
  tags = {
    Name = var.subnet_name
  }
}

# Route table association
resource "aws_route_table_association" "devops-rt-association" {
  subnet_id      = aws_subnet.devops-subnet.id
  route_table_id = aws_route_table.devops-rt.id
  depends_on     = [aws_subnet.dev-subnet, aws_route_table.dev-rt]
}


resource "aws_vpc_peering_connection" "demo-vpc-peer" {
  peer_vpc_id = aws_vpc.devops-vpc.id
  vpc_id      = aws_vpc.devops-vpc.id
  requester {

    allow_remote_vpc_dns_resolution = true

  }

  accepter {
    allow_remote_vpc_dns_resolution = true
  }
}

