resource "aws_autoscaling_group" "dev-asg" {
  name                      = "dev-asg"
  min_size                  = 1
  max_size                  = 10
  desired_capacity          = 2
  health_check_grace_period = 30
  vpc_zone_identifier = ["subnet-0cb0a1b515ec61a1e", "subnet-0ac70be794d58525d"]
  launch_template {
    id = aws_launch_template.dev-lt.id
  }
}


resource "aws_launch_template" "dev-lt" {
  name                 = "dev-lt"
  image_id             = "ami-02b49a24cfb95941c"
  key_name             = "dev.pem"  
  instance_type        = "t2.micro"
  description          = "dev-lt-desp"
  security_group_names = [aws_security_group.dev-sg.id] # reference attribute 

  # A resource or module references an attribute from another resource
  # A resource requires an output from another resource.  
}


resource "aws_security_group" "dev-sg" {
  name        = "dev-sg"
  description = "dev-sg"
  vpc_id      = "vpc-06166e084f1301d4c" // im using my default one

  # In bound rule for SSH
  ingress {
    description = "SSH"
    from_port   = 22    
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # In bound rule for to allow all traffic
  ingress {
    description = "All Traffic"
    from_port   = 0
    to_port     = 65535
    protocol    = "0"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_sns_topic" "sns_topic" {
  name = "asg-sns-topic"
}

resource "aws_sns_topic_subscription" "sns-topic-sub" {
  topic_arn = aws_sns_topic.sns_topic.arn
  endpoint = each.value
  for_each = {
    "em1" = "pvgkumar2001@gmail.com"
    "em2" = "dummy@gmail.com"
  }
  protocol = "email"
}