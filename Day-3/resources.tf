
resource "aws_instance" "ec2-instance" {
  ami = var.ami
  key_name = aws_key_pair.key_name.key_name
  # instance_type = lookup(var.instance_type, dev, "t2.micro")
  instance_type = lookup(var.instance_type, terraform.workspace, "t2.micro")
  tags = {
    Name = "ec2-instance"
    env = var.env
  }
}

resource "aws_key_pair" "key_name" {
  key_name = var.key_name
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDAtlKQrsLn1wd1CLqfxj1IU9QP2p2To5HKhy3OqN+zu795Y5i1n2hiELZzvjM2tClZA8x2aiQFjy5HKL4nFbk7VSbfIw3QDwvGjgKAkaCeEdUpU2jUF8jUsWX4dgqSUEtZyAkTVwx5qhxQ7BDdIWYm+RyFoBwiAo4Who8hCBe2xGQjp7M+nx7tFSYK3NhV9+kPq3r3bm1Y6Br5hT2Rp+/0giqDylSpHHeQoS/bP/aJIMJ1ldaPS3QsvKvyOQyTl3wlzkZQeCeB+qtKv85eLCUxJb7YT53/tHhdsf6Uvntrf0CSWeCgxmUS0r6kPsLehn3XEKFiFqvrxUTCn19NtkcF"
 
  tags = {
    Name = var.key_name
  }
}