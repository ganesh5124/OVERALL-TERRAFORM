output "pub-ip-north" {
    value = aws_instance.server-north.public_ip
}

output "pub-ip-south" {
    value = aws_instance.server-south.public_ip
}