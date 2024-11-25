terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.61.0"
    }
  }
}


resource "local_file" "file" {
  filename = var.filename[count.index]
  count = length(var.filename)
  file_permission = "0777"
  directory_permission = "0777"
}

variable "filename" {
  type = list(string)
  default = [
    "root/demo1",
    "root/demo2"
  ]
}


resource "local_file" "demo1" {
  filename = each.value
  for_each = toset(var.filename1)
}

variable "filename1" {
  type = set(string)
  default = [
    "root/filename1",
    "root/filename1"
  ]
}