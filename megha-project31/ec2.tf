resource "aws_instance" "private_instance" {
    ami = "${var.ami_map["NV"]}"
    instance_type = "${var.instance_type_list[0]}"
    subnet_id = "${aws_subnet.pravite_subnet.id}"
    tags = {
        name = "private_instance"
        Env = "${var.env}"
    }    
}
resource "aws_instance" "public_instance" {
    ami = "${var.ami_map["NV"]}"
    instance_type = "${var.instance_type_list[0]}"
    subnet_id = "${aws_subnet.public_subnet.id}"
    tags = {
        name = "public_instance"
        Env = "${var.env}"
    }
}
