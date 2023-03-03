resource "aws_vpc" "tf_vpc" {
    cidr_block = var.vpc_cidr
    tags = {
        Name = "Terravpc"
    }
}

resource "aws_internet_gateway" "terra_igw" {
    vpc_id = aws_vpc.tf_vpc.id
    tags = {
        Name = "main"
    }
}

resource "aws_subnet" "public" {
    count = length(var.public_cidr)
    vpc_id = aws_vpc.tf_vpc.id
    cidr_block = element(var.public_cidr,count.index)
    availability_zone = element(var.azs,count.index)
    map_public_ip_on_launch = true
    tags = merge(var.tags,{Name = "${var.namespace}-subnet-${count.index}"})
  
}

resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.tf_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.terra_igw.id
    }
    tags = {
      Name = "publicroutetable"
    }
}

resource "aws_route_table_association" "a" {
    count = length(var.public_cidr)
    subnet_id = element(aws_subnet.public.*.id,count.index)
    route_table_id = aws_route_table.public_rt.id
  
}