terraform {
  backend "s3" {
    bucket = "statefile"
    key = "dev/terraform.tfstate"
    region = "ap-south-1"
    encrypt = true
    dynamodb_table = "statefilestore"
  }
}

