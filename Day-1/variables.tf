
variable "ami_south" {
  default = "ami-00fa32593b478ad6e"
}

variable "ami_north" {
  default = "ami-09501f935df1c05b7"
}

variable "instance_type_south" {
  default = "t2.micro"
}

variable "instance_type_north" {
  default = "t2.micro"
}

variable "key_name_south" {
  default = "JenkinsKeys111"
}

variable "key_name_north" {
  default = "NorthEastKey"
}