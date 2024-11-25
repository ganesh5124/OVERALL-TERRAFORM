resource "aws_instance" "server-south" {
  ami = var.ami_south
  instance_type = var.instance_type_south
  provider = aws.ap-south
  key_name = var.key_name_south
  tags = {
    name = "aws-instance"
  }
}

resource "aws_instance" "server-north" {
  # for_each = {
  #   "ami1" = "ami1"
  #   "ami2" = "ami2"
  # }
  ami = var.ami_north
  # ami = each.value
  instance_type = var.instance_type_north
  key_name = var.key_name_north
  provider = aws.ap-north
  tags = {
    name = "aws-instance"
  }
  # tags = {
  #   name = each.key
  # }
}