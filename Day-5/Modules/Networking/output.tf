output "vpc" {
  value = aws_vpc.devops-vpc.id
}

output "subnet_id" {
  value = aws_subnet.devops-subnet[*].id
}

output "sg-ids" {
  value = aws_security_group.devops-sg.id
}