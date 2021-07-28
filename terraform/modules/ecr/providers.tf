terraform {
  backend "s3" {}
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
  # Configure the AWS Provider
provider "aws" {
  region = "us-gov-west-1"
  profile = "default"
}