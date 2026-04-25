terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.35.0"
    }
  }

  backend "s3" {
    bucket = "gp-project-s3-cindia"
    key    = "eks/terraform.tfstate"
    dynamodb_table = "terraform-lock-table"
    region = "ap-south-1"
    encrypt = true
  }
}

provider "aws" {
  region = "ap-south-1"
}