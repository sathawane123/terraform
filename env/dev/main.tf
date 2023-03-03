provider "aws" {
    region = "us-west-1"
    access_key = "AKIA4E24AY2SY3V7LWEP"
    secret_key = "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"
}

module "vpc" {
  source      = "../../modules/vpc"
  vpc_cidr    = "10.10.0.0/16"
  public_cidr = ["10.10.0.0/24", "10.10.1.0/24"]
  azs         = ["us-west-1a", "us-west-1c"]
  tags = {
    owner = "IATA"
  }
  namespace = "UAT"

}