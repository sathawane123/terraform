resource "aws_instance" "server" {
  ami                = var.instance_ami
  instance_type      = var.instance_type[1]
  availability_zone  = var.availability_zone
  key_name           = aws_key_pair.generated_key.key_name
  security_groups    = [aws_security_group.allow_tls.name]
  monitoring         = var.monitoring
  user_data = <<EOF
#!/bin/bash
echo "*** Installing apache2"
sudo apt update -y
sudo apt install apache2 -y
sudo echo "Hello World from $(hostname -f)" > /var/www/html/index.html
sudo systemctl start apache2
sudo systemctl enable apache2
echo "*** Completed Installing apache2"
EOF
  tags =  {
    Name = "${var.namespace}-Instance"
  }
}

resource "aws_security_group" "allow_tls" {
  name        = "${var.namespace}-SG"
  description = var.sg_description

  ingress {
    description = "ssh-port"
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

resource  "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
  
}

resource "aws_key_pair" "generated_key" {
  key_name = "${var.namespace}-key"
  public_key = tls_private_key.example.public_key_openssh
}  

resource "local_file"  "generated_key" {
  content = tls_private_key.example.private_key_pem
  filename = "tffile"
}

