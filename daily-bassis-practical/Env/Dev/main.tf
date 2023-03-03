provider "aws" {
    region = "us-west-1"
    access_key = "AKIA4E24AY2SY3V7LWEP"
    secret_key = "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"
}


module "instance" {
    source = "../../modules/instance"
    instance_type = "t2.micro"
    instance_tag =  {
    owner   = "PROAD-instance"
    enddate = "18/02/2023"
    }
}