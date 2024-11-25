# Key Pair
resource "aws_key_pair" "dev-key_pair" {
  key_name   = var.key_name
  public_key = var.public_key
  tags = {
    Name = var.key_name
  }
}

# Networking Module
module "networking" {
  source            = "../Networking"
  vpc_cidr_block    = "172.82.0.0/16"
  vpc_name          = "devops-vpc"
  igw_name          = "devops-igw"
  allow_all_route   = "0.0.0.0/0"
  rt_name           = "devops-rt"
  availability_zone = "ap-south-1a"
  subnet_name       = "devops-subnet"
  sg_name           = "devops-sg"
  sg_protocol       = "tcp"
}

# EC2-instance
resource "aws_instance" "devops-instance" {
  
 
  ami           = var.ami
  key_name      = var.key_name
  instance_type = var.instance_type
  tags = {
    Name = var.instance_tag_name
  }
  vpc_security_group_ids = [aws_security_group.devops-sg.id]
  subnet_id              = module.networking.subnet_id
  connection {
    user        = "ec2-user"
    type        = "ssh"
    host        = self.public_ip
    private_key = file("~/.ssh/id_rsa")
  }
  provisioner "remote-exec" {
    inline = [
      "sudo yum install httpd -y",
      "sudo systemctl enable httpd",
      "sudo systemctl start httpd",
      "sudo touch /var/www/html/index.html"
    ]
  }
}
