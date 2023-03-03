variable "instance_ami" {
  type        = string
  description = "this is the ami of instance"
  default     = "ami-0d50e5e845c552faf"
}

variable "instance_type" {
  type        = list(any)
  description = "instance type for the instance"
  default     = ["t2.micro", "t2.medium"]
}

variable "availability_zone" {
  type        = string
  description = "availability zone"
  default     = "us-west-1c"
}


variable "namespace" {
  type    = string
  default = "webserver"
}


variable "aws_key_pair" {
  type        = string
  description = "key-pair"
  default     = "n.california"

}