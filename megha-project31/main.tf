resource "aws_vpc" "my_vpc_king" {
    cidr_block       = "192.168.0.0/16"
    tags = {
        Name =  "my_vpc_king"
    }
}

resource "aws_subnet" "private_subnet" {
    vpc_id = "${aws_vpc.my_vpc_king.id}"
    cidr_block = "192.168.0.0/20"
    tags = {
        name = "private_subnet"
    }
     map_public_ip_on_launch = false
}

resource "aws_subnet" "public_subnet" {
    vpc_id = "${aws_vpc.my_vpc_king.id}"
    cidr_block = "192.168.16.0/20"
    tags = {
        name = "public_subnet"
    }
    map_public_ip_on_launch = true
}


resource "aws_internet_gateway" "myigw"{
    vpc_id = "${aws_vpc.my_vpc_king.id}"
    tags = {
        name = "myigw"
    }
}


resource "aws_default_route_table" "default-rt" {
    default_route_table_id = "${aws_vpc.my_vpc_king.default_route_table_id}"
    route = {
        cidr_block_id = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.myigw.id}"
    }
    tags = {
        name = "default-rt"
    }
}
