data "aws_secretsmanager_secret" "prod_db-secrets" {
  name = var.prod_db-secrets
}

data "aws_secretsmanager_secret_version" "db_secret_version" {
  secret_id = data.aws_secretsmanager_secret.prod_db-secrets.id
}

module "networking" {
  source            = "../Networking"
  vpc_cidr_block    = "172.82.0.0/16"
  vpc_name          = "devops-vpc"
  igw_name          = "devops-igw"
  allow_all_route   = "0.0.0.0/0"
  rt_name           = "devops-rt"
  availability_zone = "ap-south-1a"
  subnet_name       = "devops-subnet"
  sg_name           = "devops-sg"
  sg_protocol       = "tcp"
}

resource "aws_db_instance" "default" {
  allocated_storage      = 10
  db_name                = var.db_name
  engine                 = var.db_engine
  engine_version         = var.db_engine_version
  instance_class         = var.db_instance_class
  username               = var.db_username
  password               = data.aws_secretsmanager_secret_version.db_secret_version.secret_string
  parameter_group_name   = var.db_parameter_group_name
  skip_final_snapshot    = true
  multi_az               = true
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [module.networking.sg-ids]
}


resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = var.db_subnet_name
  subnet_ids = module.networking.subnet_id
  tags = {
    Name = aws_db_subnet_group.rds_subnet_group.name
  }
}


