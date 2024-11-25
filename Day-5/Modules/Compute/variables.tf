# EC2 INSTANCE
variable "key_name" {}
variable "public_key" {}
variable "ami" {}
variable "instance_type" {}
variable "instance_tag_name" {}
variable "login_user" {}
variable "login_type" {}

# Load Balancer
variable "lb_name" {}
variable "lb_type" {}
variable "lb_ip_address_type" {}
variable "tg_name" {}

# Target Group and Health Checks
variable "tg_target_type" {}
variable "tg_protocol" {}
variable "tg_ip_address_type" {}
variable "tg_protocol_version" {}
variable "tg_health_protocol" {}
variable "tg_health_path" {}
variable "tg_health_port" {}
variable "tg_health_healthy_threshold" {}
variable "tg_health_unhealthy_threshold" {}
variable "tg_health_timeout" {}
variable "tg_health_interval" {}
variable "tg_port" {}