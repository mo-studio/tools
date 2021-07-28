remote_state{
  backend = "s3"
  config = {
    bucket = "bespin-amp-gc-dev-terraform-state"
    
    key = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-gov-west-1"
    encrypt        = true
    dynamodb_table = "terraform-state-locks"
  }
}

