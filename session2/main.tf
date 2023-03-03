resource "aws_instance" "server" {
  ami                = var.instance_ami
  instance_type      = var.instance_type[1]
  tags               = var.instance_tags
  availability_zone = var.availability_zone
  key_name           = var.key_name
  security_groups     = [aws_security_group.allow_tls.name]
  monitoring         = var.monitoring
}

resource "aws_security_group" "allow_tls" {
  name        = var.sg_name
  description = var.sg_description

  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = var.instance_tags
}