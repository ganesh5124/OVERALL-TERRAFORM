key_name          = "dev-key_pair"
public_key        = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDeCCSYVlNfrWJY8D4dQ64Y+xkdACqY0KYhR0pQyqEkvCLJahJEaY+ANTKqsBII9RK3PRf12eqh2w0VaPbA0cQYBvzO6q/YLWRbmtqW9Sk6s2XozaAAFFOIuFrqFVvTHALOKh8RnDmqdq1PdpWRQNdq2YSDjjph98mmT8pgWxLyPAnn0xQfciRRiAvoKjJvTp+a/G5nUhik7PUdA2mgJU7oUcDHmxpBV3i+8gyHoWw49M7dxJKW3QgaudcEmWwjcUA+wlhRMp1InbiUl+Npcj9ETa3WhZqebV/1g6n3yMMoj79BL2ZuW4ujz+bZnoJXLk76vI89kYqkGs5VcU2NY0P4oOKgQ4dAy6J8bqnmioOso+jyYAEfvxkrJSQS+HiLeZg8ACRN+TPL0nZSrlLxJubf3POXV0l3RRaJ8+vptSIMiTtGmcRqiiz5s2e19VOpSLr+bnVsQldmon/uSYheeK1hsAwQkWL4GGnfuAKSHGliua2Rz13cAGnWym1fQedRDPs= pepakayalaveeraganeshkumar@Ganesh"
ami               = ""
instance_type     = "t2.micro"
instance_tag_name = "devops-instance"
login_user        = "ec2-user"
login_type        = "ssh"

# LoadBalancer
lb_name            = "devops-lb"
tg_port            = 80
lb_type            = "application"
lb_ip_address_type = "ipv4"

# Target Group
tg_name                       = "devops-tg"
tg_target_type                = "instance"
tg_protocol                   = "HTTP"
tg_ip_address_type            = "ipv4"
tg_protocol_version           = "HTTP1"
tg_health_protocol            = "HTTP"
tg_health_path                = "/"
tg_health_port                = 80
tg_health_healthy_threshold   = 2
tg_health_unhealthy_threshold = 2
tg_health_timeout             = 2
tg_health_interval            = 5
