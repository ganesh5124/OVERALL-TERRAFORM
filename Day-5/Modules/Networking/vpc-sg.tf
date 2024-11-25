locals {
  ports_in = [
    443,
    80,
    22,
    9000,0
  ]
  ports_out = [
    22,
    3389,
    80,
    443,
    8080,
    9000,0
  ]
}

resource "aws_security_group" "devops-sg" {
  name        = var.sg_name == " " ? "dummy" : "new-sg"
  description = "devops-sg-description"
  vpc_id      = aws_vpc.devops-vpc.id
  depends_on  = [aws_vpc.devops-vpc, aws_subnet.devops-subnet]
  dynamic "ingress" {
    for_each = toset(local.ports_in)
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = var.sg_protocol
      cidr_blocks = [var.allow_all_route]
    }
  }

  dynamic "egress" {
    for_each = toset(local.ports_out)

    content {
      from_port   = egress.value
      to_port     = egress.value
      protocol    = var.sg_protocol
      cidr_blocks = [var.allow_all_route]
    }
  }

  tags = {
    Name = var.sg_name
  }
}

