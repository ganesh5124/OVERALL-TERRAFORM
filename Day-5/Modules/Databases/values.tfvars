# RDS VALUES
prod_db-secrets         = "prod_db-secrets"
db_name                 = "mydb"
db_engine               = "mysql"
db_engine_version       = "8.0"
db_instance_class       = "db.t3.micro"
db_username             = "foo"
db_parameter_group_name = "default.mysql8.0"
db_subnet_name          = "rds-subnet-grp"

# SECRETS
pass_length = 10
pass_special = true
pass_override_special = "!#$%&*()-_=+[]{}<>:?"
secrets_name = "prod_db-secrets"