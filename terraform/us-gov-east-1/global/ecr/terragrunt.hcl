include {
  path = find_in_parent_folders()
}

terraform{
    source = "../../../modules/ecr"

}


inputs = {
  ecr_repos = [
    "amp-keycloak", "amp-api", "amp-dashboard", "amp-app"
  ]

  profile = "bespin"

  region = "us-gov-west-1"
}