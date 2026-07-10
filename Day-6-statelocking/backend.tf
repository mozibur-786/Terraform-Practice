terraform {
  backend "s3" {
    bucket = "aizen-s3"
    key = "terraform.tfstate"
    region = "us-east-1"
    use_lockfile = true

  }
}
