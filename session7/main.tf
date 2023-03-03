provider "aws" {
    region = "us-west-1"
    access_key = "AKIA4E24AY2SY3V7LWEP"
    secret_key = "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"
}

resource "aws_instance" "server" {
  ami                    = var.instance_ami
  instance_type          = var.instance_type[1]
  availability_zone      = var.availability_zone
  key_name               = var.aws_key_pair
  vpc_security_group_ids = ["${aws_security_group.allow_tls.id}"]
  user_data              = file("script.sh")
  tags = {
    Name = "${var.namespace}-Instance"
  }
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  dynamic "ingress" {
    for_each = [80, 8080, 443, 22]
    iterator = port
    content {
      description = "TLS from VPC"
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}