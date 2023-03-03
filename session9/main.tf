resource "aws_key_pair" "dove-key" {
  key_name   = "dovekey"
  public_key = file("dovekey.pub")
}


resource "aws_security_group" "rock" {
  name        = "SG"
  description = var.sg_description

  ingress {
    description = "ssh-port"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


   ingress {
    description = "HTTP-port"
    from_port   = 80
    to_port     = 80
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



resource "aws_instance" "dove-inst" {
  ami                    = var.instance_ami
  instance_type          = var.instance_type[1]
  availability_zone      = var.availability_zone
  key_name               = aws_key_pair.dove-key.key_name
  vpc_security_group_ids = [aws_security_group.rock.id]
  tags = {
    Name    = "Dove-Instance"
    Project = "Dove"
  }



  provisioner "file" {
    source      = "web.sh"
    destination = "/tmp/web.sh"
  }

  provisioner "remote-exec" {

    inline = [
      "chmod +x /tmp/web.sh",
      "sudo /tmp/web.sh"
    ]
  }

  connection {
    user        = var.USER
    private_key = file("dovekey")
    host        = self.public_ip
  }
}


