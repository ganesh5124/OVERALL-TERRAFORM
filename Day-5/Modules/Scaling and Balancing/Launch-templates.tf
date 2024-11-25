resource "aws_launch_template" "server-LT" {
  name = "server-LT"
  tags = {
    name = "server-LT"
  }
  key_name = "JenkinsKeys111.pem"
  instance_type = "t2.micro"
  image_id = "ami-068e0f1a600cd311c"
  vpc_security_group_ids = [aws_vpc.devops-vpc.id]
}