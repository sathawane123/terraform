resource "aws_vpc" "my-vpc" {
  cidr_block       = "192.168.0.0/19"
  instance_tenancy = "default"

  tags = {
    Name = "my-vpc"
  }
}
resource "aws_subnet" "public-1" {
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = "192.168.1.0/24"
  availability_zone = "us-west-1a"

  tags = {
    Name = "public-1"
  }
  map_public_ip_on_launch = true
}

resource "aws_subnet" "public-2" {
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = "192.168.2.0/24"
  availability_zone = "us-west-1c"

  tags = {
    Name = "public-2"
  }
  map_public_ip_on_launch = true
}
resource "aws_subnet" "private-web-1" {
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = "192.168.3.0/24"
   availability_zone = "us-west-1a"

  tags = {
    Name = "private-web1-sunbet"
  }
  map_public_ip_on_launch = false
}
resource "aws_subnet" "private-web-2" {
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = "192.168.4.0/24"
   availability_zone = "us-west-1c"

  tags = {
    Name = "private-web2-sunbet"
  }
  map_public_ip_on_launch = false
}
resource "aws_subnet" "private-app-1" {
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = "192.168.5.0/24"
   availability_zone = "us-west-1a"

  tags = {
    Name = "private-app-1"
  }
  map_public_ip_on_launch = false
}
resource "aws_subnet" "private-app-2" {
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = "192.168.6.0/24"
   availability_zone = "us-west-1c"

  tags = {
    Name = "private-app-2"
  }
  map_public_ip_on_launch = false
}
resource "aws_eip" "elastic-ip" {
  vpc = true
  tags = {
    name = "elastic-ip"
  }
}
resource "aws_nat_gateway" "my-nat" {
  allocation_id = aws_eip.elastic-ip.id
  subnet_id     = aws_subnet.public-2.id

  tags = {
    Name = "my-nat"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my-vpc.id

  tags = {
    Name = "igw"
  }
}

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.my-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-rt"
  }
}


resource "aws_route_table" "web-rt" {
  vpc_id = aws_vpc.my-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.my-nat.id
  }

  tags = {
    Name = "web-rt"
  }
}


resource "aws_route_table" "app-rt" {
  vpc_id = aws_vpc.my-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.my-nat.id
  }

  tags = {
    Name = "app-rt"
  }
}


resource "aws_route_table_association" "pub-rt-association1" {
  subnet_id      = aws_subnet.public-1.id
  route_table_id = aws_route_table.public-rt.id
}
resource "aws_route_table_association" "pub-rt-association2" {
  subnet_id      = aws_subnet.public-2.id
  route_table_id = aws_route_table.public-rt.id
}


resource "aws_route_table_association" "web-rt-association1" {
  subnet_id      = aws_subnet.private-web-1.id
  route_table_id = aws_route_table.web-rt.id
}
resource "aws_route_table_association" "web-rt-association2" {
  subnet_id      = aws_subnet.private-web-2.id
  route_table_id = aws_route_table.web-rt.id
}


resource "aws_route_table_association" "app-rt-association1" {
  subnet_id      = aws_subnet.private-app-1.id
  route_table_id = aws_route_table.app-rt.id
}
resource "aws_route_table_association" "app-rt-association2" {
  subnet_id      = aws_subnet.private-app-2.id
  route_table_id = aws_route_table.app-rt.id
}


resource "aws_instance" "jump-server" {
  ami                    = "ami-00569e54da628d17c"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.three-tier-sg.id]
  key_name               = aws_key_pair.key.key_name
  subnet_id              = aws_subnet.public-1.id
  monitoring             = false
  tags = {
    name = "jump-server"
  }
}


resource "aws_instance" "nginx-1" {
  ami                    = "ami-00569e54da628d17c"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.three-tier-sg.id]
  key_name               = aws_key_pair.key.key_name
  subnet_id              = aws_subnet.private-web-1.id
  monitoring             = false
  user_data              = var.user_data
  tags = {
    name = "nginx-1"
  }
}


resource "aws_instance" "nginx-2" {
  ami                    = "ami-00569e54da628d17c"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.three-tier-sg.id]
  key_name               = aws_key_pair.key.key_name
  subnet_id              = aws_subnet.private-web-2.id
  monitoring             = false
  user_data              = var.user_data
  tags = {
    name = "nginx-2"
  }
}

resource "aws_instance" "tomcat-1" {
  ami                    = "ami-00569e54da628d17c"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.three-tier-sg.id]
  key_name               = aws_key_pair.key.key_name
  subnet_id              = aws_subnet.private-app-1.id
  monitoring             = false
  user_data              = var.user_data2
  tags = {
    name = "tomcat-1"
  }
}

resource "aws_instance" "tomcat-2" {
  ami                    = "ami-00569e54da628d17c"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.three-tier-sg.id]
  key_name               = aws_key_pair.key.key_name
  subnet_id              = aws_subnet.private-app-2.id
  monitoring             = false
  user_data              = var.user_data2
  tags = {
    name = "tomcat-2"
  }
}





resource "aws_security_group" "three-tier-sg" {
  name   = "tomcat and mysql and http and ssh and https"
  vpc_id = aws_vpc.my-vpc.id

  ingress {
    description = "tomcat"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "https"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "mySQL"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ssh"
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
}


resource "tls_private_key" "my_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key" {
  key_name   = "ncal123-key"
  public_key = tls_private_key.my_key.public_key_openssh
}

resource "local_file" "key" {
  content  = tls_private_key.my_key.private_key_pem
  filename = "ncal123-key"
}



resource "aws_s3_bucket" "tomcat-demon" {
  bucket = "tomcat-demon123456789"

  tags = {
    name = "tomcat-demon"
  }
}


resource"aws_s3_bucket_acl" "object_bucket"{
    bucket = aws_s3_bucket.tomcat-demon.bucket
    acl = "public-read"
}

resource "aws_s3_object" "object" {

  bucket = aws_s3_bucket.tomcat-demon.bucket
  key    = "tomcat-daemon.service.txt"
  source = "./tomcat-daemon.service.txt"
}


resource "aws_s3_object" "object2" {

  bucket = aws_s3_bucket.tomcat-demon.bucket
  key    = "student.war"
  source = "./student.war"
}

resource "aws_s3_object" "object3" {

  bucket = aws_s3_bucket.tomcat-demon.bucket
  key    = "mysql-connector.jar"
  source = "./mysql-connector.jar"
}



resource "aws_lb" "nginx-lb" {
  name               = "nginx-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.three-tier-sg.id]
  subnets            = [
                        aws_subnet.public-1.id,
                        aws_subnet.public-2.id
                      ]

  enable_deletion_protection = false

  tags = {
   Environment = "prod"
  }
}
resource "aws_lb_target_group" "nginx-tg" {
  name     = "nginx-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.my-vpc.id
}
resource "aws_lb_listener" "nginx-list" {
  load_balancer_arn = aws_lb.nginx-lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx-tg.arn
  }
}




resource "aws_lb_target_group_attachment" "nginx-lb1" {
  target_group_arn = aws_lb_target_group.nginx-tg.arn
  target_id        = aws_instance.nginx-1.id
  port             = 80

  depends_on = [
    aws_instance.nginx-1,
  ]
}

resource "aws_lb_target_group_attachment" "nginx-lb2" {
  target_group_arn = aws_lb_target_group.nginx-tg.arn
  target_id        = aws_instance.nginx-2.id
  port             = 80

  depends_on = [
    aws_instance.nginx-2,
  ]
}









resource "aws_lb" "tomcat-lb" {
  name               = "tomcat-lb-tf"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.three-tier-sg.id]
  subnets            = [
                        aws_subnet.private-app-1.id,
                        aws_subnet.private-app-2.id
                      ]

  enable_deletion_protection = false

  tags = {
   Environment = "prod2"
  }
}
resource "aws_lb_target_group" "tomcat-tg" {
  name     = "tomcat-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.my-vpc.id
}
resource "aws_lb_listener" "tomcat-list" {
  load_balancer_arn = aws_lb.tomcat-lb.arn
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tomcat-tg.arn
  }
}




resource "aws_lb_target_group_attachment" "tomcat-lb1" {
  target_group_arn = aws_lb_target_group.tomcat-tg.arn
  target_id        = aws_instance.tomcat-1.id
  port             = 8080

  depends_on = [
    aws_instance.tomcat-1,
  ]
}

resource "aws_lb_target_group_attachment" "tomcat-lb2" {
  target_group_arn = aws_lb_target_group.tomcat-tg.arn
  target_id        = aws_instance.tomcat-2.id
  port             = 8080

  depends_on = [
    aws_instance.tomcat-2,
  ]
}



# Create Database Private Subnet

resource "aws_subnet" "database-1" {
  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = "192.168.7.0/24"
  availability_zone = "us-west-1a"

  tags = {
    Name = "database-1"
  }
}

resource "aws_subnet" "database-2" {
  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = "192.168.8.0/24"
  availability_zone = "us-west-1c"

  tags = {
    Name = "database-2"
  }
}




resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = [aws_subnet.database-1.id, aws_subnet.database-2.id]

  tags = {
    Name = "mydb subnet group"
  }
}

# Create Database Security Group

resource "aws_security_group" "database-sg" {
  name        = "database-sg"
  description = "Allow inbound traffic from application layer"
  vpc_id      = aws_vpc.my-vpc.id

  ingress {
    description     = "Allow traffic from application layer"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.three-tier-sg.id]
  }

  egress {
    from_port   = 32768
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "database-sg"
  }
}


resource "aws_db_instance" "default" {
  allocated_storage      = 20
  db_subnet_group_name   = aws_db_subnet_group.default.id
  engine                 = "mySQL"
  engine_version         = "8.0.28"
  instance_class         = "db.t2.micro"
  multi_az               = true
  db_name                = "student"
  username               = "admin"
  password               = "admin123"
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.database-sg.id]
}

output "lb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = aws_lb.nginx-lb.dns_name
}




































      