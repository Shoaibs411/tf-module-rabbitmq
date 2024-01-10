# Datasource to fetch the information from the VPC Remote Statefile
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket  = "b56-terraform-state--bucket"
    key     = "vpc/${var.ENV}/terraform.tfstate"
    region  = "us-east-1"
  }
}

data "aws_ami" "ami" {
  most_recent      = true
  name_regex       = "DevOps-LabImage-CentOS7"
  owners           = ["355449129696"]
}

# Extracting the information of the secret
data "aws_secretsmanager_secret" "secrets" {
  name = "roboshop/secrets"
}

# Extracting the secret version from the secret
data "aws_secretsmanager_secret_version" "secret_version" {
  secret_id = data.aws_secretsmanager_secret.secrets.id
}