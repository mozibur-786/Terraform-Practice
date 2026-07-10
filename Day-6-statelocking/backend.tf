terraform {
  backend "s3" {
    bucket = "aizen-s3"
    key = "terraform.tfstate"
    region = "us-east-1"
    use_lockfile = true       #it will create a lock file in the s3 bucket to avoid concurrent modifications of the state file. 


  }
}

# this wont allow multiple users to modify the state file at the same time.