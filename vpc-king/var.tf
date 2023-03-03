# variable "region" {
#   type        = string
#   description = "region for instance"
#   default     = "us-east-1"
# }


# variable "profile" {
#   type        = string
#   description = "profile"
#   default     = "tf-user"
# }

variable "instance_ami" {
  type        = string
  description = "ami id for instance"
  default     = "ami-00569e54da628d17c"
}

variable "instance_type" {
  type        = string
  description = "instance type for instance"
  default     = "t2.micro"
}

variable "security_group_name" {
  type        = string
  description = "groupname for instance_security_group"
  default     = "webserve-sg"
}

variable "azs" {
  default = {
    "subnet-1" = "us-east-1a"
    "subnet-2" = "us-east-1b"
    "subnet-3" = "us-east-1c"
    "subnet-4" = "us-east-1d"
    "subnet-5" = "us-east-1e"

  }
}


variable "security_group_description" {
  type        = string
  description = "description for instance_security_group"
  default     = "instance security group"
}

variable "monitoring" {
  type        = bool
  description = "desable monitoring"
  default     = "false"

}

variable "namespace" {
  type        = string
  description = "namespace"
  default     = "my"
}

variable "user_data" {
  type        = string
  description = "namespace"
  default     = <<-EOF
            #!/bin/bash
            sudo yum update -y
            sudo amazon-linux-extras install nginx1 -y
            sudo systemctl start nginx
            sudo systemctl enable nginx
            EOF
}

variable "user_data2" {
  type        = string
  description = "namespace"
  default     = <<-EOF
#!/bin/bash
sudo yum install java-openjdk -y
wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.71/bin/apache-tomcat-9.0.71.tar.gz
curl -O https://tomcat-demon123456789.s3.us-west-1.amazonaws.com/tomcat-daemon.service.txt
sudo mv tomcat-daemon.service /etc/systemd/system/tomcat-daemon.service
sudo tar -xvzf apache-tomcat-9.0.71.tar.gz 
sudo mv apache-tomcat-9.0.71 /opt/tomcat
sudo cd /opt/tomcat/webapps
sudo curl -O https://tomcat-demon123456789.s3.us-west-1.amazonaws.com/student.war
sudo systemctl daemon-reload
sudo systemctl start tomcat-daemon
sudo systemctl enable tomcat-daemon
sudo curl -O https://tomcat-demon123456789.s3.us-west-1.amazonaws.com/mysql-connector.jar
sudo mv mysql-connector.jar /opt/tomcat/lib
sudo mv student.war /opt/tomcat/webapps/
EOF
}