terraform {
  backend "s3" {
    bucket = "youngyznationcloud1"
    key    = "youngyznation1/production/terraform.tfstate"
    region = "us-east-1"
  }
}