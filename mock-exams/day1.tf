resource "tls_private_key" "datacenter_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Save the private key to a file
resource "local_file" "private_key_pem" {
  content  = tls_private_key.datacenter_key.private_key_pem
  filename = "/home/bob/datacenter-kp.pem"
  file_permission = "0600"
}

# Create the AWS Key Pair using the public key
resource "aws_key_pair" "datacenter_kp" {
  key_name   = "datacenter-kp"
  public_key = tls_private_key.datacenter_key.public_key_openssh
}

# The name of the security group must be xfusion-sg.

# 2) The description must be Security group for Nautilus App Servers.

# 3) Add an inbound rule of type HTTP, with a port range of 80, and source CIDR range 0.0.0.0/0.

# 4) Add another inbound rule of type SSH, with a port range of 22, and source CIDR range 0.0.0.0/0.

resource "aws_security_group" "xfusion-sg" {
  description = "Security group for Nautilus App Servers"
    name        = "xfusion-sg" 
    tags = {
      "Name" = "xfusion-sg"
    }

}

resource "aws_security_group_rule" "http" {
    security_group_id = aws_security_group.xfusion-sg.id
    from_port         = 80
    to_port           = 80
    protocol          = "http"
    type             = "ingress"
    cidr_blocks       = ["0.0.0.0/0"]
  
}

resource "aws_security_group_rule" "ssh" {
    security_group_id = aws_security_group.xfusion-sg.id
    type    = "ingress"
    from_port = 22
    to_port   = 22
    protocol = "ssh"
    cidr_blocks = [ "0.0.0.0/0" ]
}


# Create VPC
resource "aws_vpc" "datacenter-vpc-t5q1" {
    # ipv6 cidr_block = "2600:1f18:1b2:3c4d::/64"
    cidr_block = "10.0.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
        Name = "datacenter-vpc-t5q1"
    }
  
}

resource "aws_ebs_snapshot" "nautilus-vol-ss" {
  
  description = "Nautilus Snapshot"
  volume_id   = aws_ebs_volume.nautilus-vol.id
  tags = {
    Name = "nautilus-vol-ss"
  }
}

resource "aws_cloudwatch_metric_alarm" "xfusion-alarm" {
  alarm_name          = "xfusion-alarm"
  metric_name  = "CPUUtilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods = 1
  threshold = 80
  namespace    = "AWS/EC2"
  period = 300
}

resource "aws_cloudwatch_metric_alarm" "foobar" {
  alarm_name                = "terraform-test-foobar5"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 2
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 120
  statistic                 = "Average"
  threshold                 = 80
  alarm_description         = "This metric monitors ec2 cpu utilization"
  insufficient_data_actions = []
}


resource "aws_iam_policy" "iampolicy_javed" {
  name = "iampolicy_javed"
  description = "IAM policy for Javed"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:Describe*",
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "iampolicy_javed_policy_attach" {
  name       = "iampolicy_javed_policy_attach"
  policy_arn = aws_iam_policy.iampolicy_javed.arn
  users      = ["javed"]
}

resource "aws_dynamodb_table" "xfusion-users" {
  name         = "xfusion-users"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "xfusion_id"

  attribute {
    name = "xfusion_id"
    type = "S"
  }
}

resource "aws_kinesis_stream" "nautilus-stream" {
  name        = "nautilus-stream"
  shard_count = 1
  retention_period = 24 # hours
  tags = {
    Name = "nautilus-stream"
  }
}

resource "aws_sns_topic" "datacenter-notifications-t3q4" {
  name = "datacenter-notifications-t3q4"
  display_name = "Nautilus Topic"
  tags = {
    Name = "datacenter-notifications-t3q4"
  }
}

resource "aws_ssm_parameter" "nautilus-parameter" {
  name        = "nautilus-parameter"
  description = "Nautilus SSM Parameter"
  type        = "String"
  value       = "Nautilus Value"
  tags = {
    Name = "nautilus-parameter"
  }
  
}

resource "aws_cloudwatch_log_group" "xfusion-log-group" {
  name              = "xfusion-log-group"
  retention_in_days = 14
  tags = {
    Name = "xfusion-log-group"
  }
  
}

resource "aws_cloudwatch_log_stream" "xfusion-log-stream" {
  name           = "xfusion-log-stream"
  log_group_name = aws_cloudwatch_log_group.xfusion-log-group.name
  }
resource "aws_opensearch_domain" "datacenter-es" {
  domain_name = "datacenter-es"
  tags = {
    Name = "datacenter-es"
  }
}


resource "aws_instance" "ec2" {
  ami           = "ami-0c101f26f147fa7fd"
  instance_type = "t2.micro"
  subnet_id     = "subnet-68f1926f1947854c4"
  vpc_security_group_ids = [
    "sg-6079db88d61454a92"
  ]
  
  tags = {
    Name = "xfusion-ec2"
  }
}

# Provision Elastic IP
resource "aws_eip" "ec2_eip" {
  tags = {
    Name = "xfusion-ec2-eip"
  }
}

resource "aws_eip_association" "sample" {
  instance_id = aws_instance.ec2.id
  allocation_id = aws_eip.ec2_eip.id  
}
resource "aws_iam_user" "user" {
  name = "iamuser_mark"

  tags = {
    Name = "iamuser_mark"
  }
}

# Create IAM Policy
resource "aws_iam_policy" "policy" {
  name        = "iampolicy_mark"
  description = "IAM policy allowing EC2 read actions for mark"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["ec2:Read*"]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "policy_attachment" {
  name       = "iampolicy_mark_attachment"
  policy_arn = aws_iam_policy.policy.arn
  users      = [aws_iam_user.user.name]
  
}

resource "aws_s3_bucket" "s3_ran_bucket" {
  bucket = "datacenter-s3-29924"
  acl    = "private"
  versioning {
    enabled = true
  }

  tags = {
    Name        = "datacenter-s3-29924"
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.s3_ran_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
  
}

resource "aws_s3_object_copy" "copy_object" {
  source = "/opt/s3-backup/"
  bucket        = "datacenter-bck-28453"
  key           = "copied-file.txt"

  tags = {
    Name = "copied-file"
  }
  
}

resource "aws_vpc" "devops-vpc" {
  cidr_block = "10.0.0.0/16"
  ipv6_cidr_block = "2600:1f18:1b2:3c4d::/64"
  enable_dns_support = true
  tags = {
    "Name" = var.KKE_vpc
  }
}

variable "KKE_vpc" {
  default = "devops-vpc"
}

variable "KKE_eip" {
  default = "devops-eip"
}

resource "aws_eip" "devops-eip" {
  tags = {
    Name = var.KKE_eip
  }
}

resource "aws_iam_group" "iamgroup_yousuf_t2q2" {
  name = "iamgroup_yousuf_t2q2"
}

resource "aws_iam_role" "iamrole_anita" {
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
  name = var.KKE_iamrole
}
variable "KKE_iamrole" {
  default = "iamrole_anita"
}

resource "aws_iam_policy" "iampolicy_jim" {
  name = var.KKE_iampolicy
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [ "ec2:Describe*"
        ]
        Resource = "*"
      }
    ]
  })
}

variable "KKE_iampolicy" {
  default = "iampolicy_jim"
}