variable "vpc-cidr_block" {
  default = "10.81.0.0/16"
  description = "Vpc cidr block"
  type = string
}

variable "instance_tenancy" {
  default = "default"
}

variable "route-table-cidr_block" {
  default = "0.0.0.0/0"
}

variable "vpc-subnet-cidr-block" {
  default = "10.81.1.0/24"
}

variable "ni-private-ips" {
  default = ["10.81.3.33"]
}

variable "associate_with_private_ip" {
  default = "10.81.3.33"
}

variable "ami-prod" {
  default = "ami-00fa32593b478ad6e"
}

variable "prod-instance_type" {
  default = "t2.micro"
}

#  Condition Expression for to create ec2 instance
variable "instances" {
  default = true
  type = bool
  description = "Creating instance by conditional statements"
}

variable "key_name" {
  default = "JenkinsKeys111"
}