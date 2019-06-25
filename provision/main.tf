provider "aws" {
  access_key = "${var.AWS_ACCESS_KEY}"
  secret_key = "${var.AWS_SECRET_KEY}"
  region     = "eu-central-1"
  version = "~> 2.7"
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}