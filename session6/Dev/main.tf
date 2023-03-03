module "instance" {
  source = "../modules/instance"
  instance_ami = "ami-00569e54da628d17c"
  availability_zone = "us-west-1c"
  monitoring = "false"
  namespace = "rockeybhai"
}
