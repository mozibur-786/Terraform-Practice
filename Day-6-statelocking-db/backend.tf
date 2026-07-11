terraform {
  backend "s3" {
    bucket = "aizen-s3"
    key = "terraform.tfstate"
    region = "us-east-1"
    #use_lockfile = true
    dynamodb_table = "aizen-db"  #db state locking will be used to avoid concurrent modifications of the state file.
  }
}