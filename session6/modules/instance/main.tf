resource "aws_instance" "webserver" {
  ami               = var.instance_ami
  instance_type     = "t2.micro"
  availability_zone = var.availability_zone
  monitoring        = var.monitoring
  key_name          =  "n.california"
  tags = {
    name = "${var.namespace}-instance"
  }
}
# resource "aws_security_group" "tg-sg" {
#   name        = var.security_group_name
#   description = var.security_group_description

#   ingress {
#     description = "httpd"
#     from_port   = 8080
#     to_port     = 8080
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     description = "httpd"
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     description = "ssh"
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }
# }


# resource "tls_private_key" "my_key" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }

# resource "aws_key_pair" "key" {
#   key_name   = "${var.namespace}-key"
#   public_key = tls_private_key.my_key.public_key_openssh
# }

# resource "local_file" "key" {
#   content  = tls_private_key.my_key.private_key_pem
#   filename = "RRR"