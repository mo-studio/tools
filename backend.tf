terraform {
  backend "s3" {
    bucket         = "bespin-amp-gc-dev-terraform-state"
    key            = "amp/terraform.tfstate"
    region         = "us-gov-west-1"
    dynamodb_table = "terraform-state-locks"
  }
}