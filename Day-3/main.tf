
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "ap-south-1"
}

variable "ami" {
  default = "ami-00fa32593b478ad6e"
}
variable "instance_type" {
  type = map(string)

  default = {
    "dev" = "t2.micro"
    "prod" = "t2.medium"
    "sbox" = "t3.micro"
  }
}
variable "key_name" {
  default = "JenkinsKeys111"
}

resource "aws_instance" "ec2-instance" {
  ami = var.ami
  key_name = var.key_name
  # instance_type = lookup(var.instance_type, dev, "t2.micro")
  instance_type = lookup(var.instance_type, terraform.workspace, "t2.micro")
  tags = {
    Name = "ec2-instance"
  }
}