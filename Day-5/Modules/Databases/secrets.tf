resource "random_password" "db-password" {
  length = var.pass_length
  special = var.pass_special
  override_special = var.pass_override_special
}


resource "aws_secretsmanager_secret" "prod_db-secrets" {
  name = var.secrets_name
}

resource "aws_secretsmanager_secret_version" "db_secret_version" {
  secret_id = aws_secretsmanager_secret.prod_db-secrets.id
  secret_string = random_password.db-password.result
}