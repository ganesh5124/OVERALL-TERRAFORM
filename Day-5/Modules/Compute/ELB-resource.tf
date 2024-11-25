resource "aws_lb" "devops-lb" {
  name = var.lb_name
  load_balancer_type = var.lb_type // network , gatway
  internal = false
  ip_address_type = var.lb_ip_address_type
  subnet_mapping {
    # subnet_id = aws_subnet.devops-subnet-public.id
    subnet_id = module.networking.subnet_id.id
  }

  subnet_mapping {
    # subnet_id = aws_subnet.devops-subnet-private.id
     subnet_id = module.networking.subnet_id.id
  }
  security_groups = [module.networking.sg-ids]
  
  tags = {
    name = var.lb_name
  }
}






