resource "aws_ami" "ami-create" {
  name = aws_launch_template.server-LT.id
}