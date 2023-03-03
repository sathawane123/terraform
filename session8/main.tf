provider "aws" {
    region = "us-west-1"
    access_key = "AKIA4E24AY2SY3V7LWEP"
    secret_key = "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"
}


resource "aws_s3_bucket" "viratfan123" {
  bucket = "viratfan123"

  tags = {
    Name        = "viratfan123"
    Environment = "Dev"
  }
}


terraform {
  backend "s3" {
    bucket = "viratfan123"
    key    = "gogo/s3/terraform.tfstate"
    region = "us-west-1"
  }
}