# RDS VARIABLES
variable "prod_db-secrets" {}
variable "db_name" {}
variable "db_engine" {}
variable "db_engine_version" {}
variable "db_instance_class" {}
variable "db_username" {}
variable "db_parameter_group_name" {}
variable "db_subnet_name" {}
# 
# RDS SECRETS VARIABLES
variable "pass_length" {}
variable "pass_special" {}
variable "pass_override_special" {}
variable "secrets_name" {}