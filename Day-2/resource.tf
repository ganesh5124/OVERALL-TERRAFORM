# Creating vpc
resource "aws_vpc" "dev-vpc" {
  cidr_block       = var.vpc-cidr_block
  instance_tenancy = var.instance_tenancy
  tags = {
    Name = "dev-vpc"
  }
}
# Creating Internet Gateway and linking with vpc (dev-vpc)
resource "aws_internet_gateway" "dev-vpc-igw" {
  vpc_id = aws_vpc.dev-vpc.id

  tags = {
    Name = "dev-vpc-igw"
  }
}

# Creating custom route table
resource "aws_route_table" "dev-vpc-route-table" {
  vpc_id = aws_vpc.dev-vpc.id
  route {
    cidr_block = var.route-table-cidr_block
    gateway_id = aws_internet_gateway.dev-vpc-igw.id
  }

  tags = {
    Name = "dev-vpc-route-table"
  }
}

# Creating Subnet
resource "aws_subnet" "dev-subnet" {
  cidr_block = var.vpc-subnet-cidr-block
  vpc_id     = aws_vpc.dev-vpc.id
  tags = {
    Name = "dev-subnet"
  }
}

# Associate subnet with route table
resource "aws_route_table_association" "dev-subnet-association" {
  subnet_id      = aws_subnet.dev-subnet.id
  route_table_id = aws_route_table.dev-vpc-route-table.id
}

# Create Security Group to allow port 22 80 443 or all ports and all the traffic
resource "aws_security_group" "dev_sg" {
  # Inbound Rules
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound Rules
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "dev_sg"
  }
}

# creating network interface and linking with subnet and security groups
resource "aws_network_interface" "dev-ni" {
  subnet_id = aws_subnet.dev-subnet.id
  private_ips = var.ni-private-ips
  security_groups = [ aws_security_group.dev_sg.id ]

  tags = {
    Name = "dev-ni"
  }
}

# Assign an elastic IP to the network interface created in step 7
resource "aws_eip" "prod-eip" {
  network_interface = aws_network_interface.dev-ni.id
  associate_with_private_ip = var.associate_with_private_ip
  tags = {
    Name = "prod-eip"
  }
}

# Create an ec2 server - Launch an Application in IT
resource "aws_instance" "prod-instance" {
  ami           = var.ami-prod
  instance_type = var.prod-instance_type
  count         = var.instances ? 1 : 0
  key_name      = var.key_name
  user_data = "${file("script.sh")}"
  tags = {
    Name = "prod-instance"
  }
}





