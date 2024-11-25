provider "aws" {
  region = "ap-south-1"
}

resource "aws_vpc" "prov-vpc" {
  cidr_block       = "10.81.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "prov-vpc"
  }
}

resource "aws_internet_gateway" "prov-igw" {
  vpc_id = aws_vpc.prov-vpc.id
}

resource "aws_subnet" "prov-subnet" {
  vpc_id                  = aws_vpc.prov-vpc.id
  cidr_block              = "10.81.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

}

resource "aws_route_table" "prov-RT" {
  vpc_id = aws_vpc.prov-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.prov-igw.id
  }
}

resource "aws_route_table_association" "prov_rt_association" {
  subnet_id      = aws_subnet.prov-subnet.id
  route_table_id = aws_route_table.prov-RT.id
}

resource "aws_security_group" "provsg" {
  name   = "provsg"
  vpc_id = aws_vpc.prov-vpc.id
  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "http"
    from_port   = 8080
    to_port     = 8080
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow All"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "provsg"
  }

}
resource "aws_instance" "ec2-instance" {
  ami                    = "ami-0e1d06225679bc1c5"
  key_name               = "dev"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.prov-subnet.id
  vpc_security_group_ids = [aws_security_group.provsg.id]
  tags = {
    Name = "ec2-instance1"
  }
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("/Users/pepakayalaveeraganeshkumar/AWS/dev.pem")
    host        = self.public_ip
  }
  provisioner "file" {
    source      = "./app.py"
    destination = "/tmp/app.py"
  }

  provisioner "local-exec" {
    command = "echo 'hey hi came here' >> dummy.txt"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo yum update –y",
      "sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo",

      "sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key",

      "sudo yum upgrade",
      "sudo dnf install java-17-amazon-corretto -y",
      "sudo yum install jenkins -y",
      "sudo systemctl enable jenkins",
      "sudo systemctl start jenkins",
      "cat /var/lib/jenkins/secrets/initialAdminPassword"
    ]

  }
}
