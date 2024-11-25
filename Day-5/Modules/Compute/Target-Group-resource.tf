resource "aws_lb_target_group" "devops-tg" {
  name        = var.tg_name
  port        = var.tg_port
  target_type = var.tg_target_type // lambda
  # target_id = 
  protocol         = var.tg_protocol
  ip_address_type  = var.tg_ip_address_type
  protocol_version = var.tg_protocol_version
  vpc_id           = module.networking.vpc.id
  health_check {
    protocol            = var.tg_health_protocol
    path                = var.tg_health_path
    port                = var.tg_health_port
    healthy_threshold   = var.tg_health_healthy_threshold
    unhealthy_threshold = var.tg_health_unhealthy_threshold
    timeout             = var.tg_health_timeout
    interval            = var.tg_health_interval
  }
  tags = {
    Name = var.tg_name
  }

}
