terraform {
  backend "s3" {
    bucket = "ofiliyoungyzcloud1"
    key    = "ofiliyoungyz/production/terraform.tfstate"
    region = "us-east-1"
  }
}