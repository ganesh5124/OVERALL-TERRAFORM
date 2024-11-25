# Terraform required providers
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.61.0"
    }
  }
}

# Region specific 
provider "aws" {
  region = "ap-south-1"
  alias = "ap-south"
  profile = "default"
}

# Created EBS volume 
resource "aws_ebs_volume" "vol1" {
  availability_zone = "ap-south-1a"
  type = "gp3"
  size = 1
  iops = 3000
  throughput = 125
  tags = {
    "Name" = "aws-ebs-volume"
  }
}

# Attached volume to Ec2 Instance (nodeserv)
resource "aws_volume_attachment" "volume-attach" {
  volume_id = aws_ebs_volume.vol1.id
  instance_id = aws_instance.nodeserv.id
  device_name = "/dev/sdh"
}

# Created EC2 Instance
resource "aws_instance" "nodeserv" {
  ami = "ami-0a4408457f9a03be3"
  key_name = "dev"
  availability_zone = "ap-south-1a"
  instance_type = "t2.micro"
  tags = {
    Name = "nodeserv"
  }
  security_groups = ["sg-002f634c7445e704f"]
  
  connection {
    type = "ssh"
    user = "ec2-user"
    host = self.public_ip
    private_key = file("~/AWS/key-pairs/dev.pem")
  }

  provisioner "remote-exec" {
    inline = [ 
      "sudo mkfs.ext4 /dev/xvdf",
      "sudo mkdir /Ganesh",
      "sudo mount -t ext4 /dev/xvdf Ganesh",
     ]
  }
}

resource "aws_ebs_snapshot" "ebs-snap" {
  volume_id = aws_ebs_volume.vol1.id
  description = "EBS Snapshot for Volume"
  tags = {
    name = "ebs-snap"
  }
}


