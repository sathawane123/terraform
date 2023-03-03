variable "ami_map" {
    default = {
        NV = "ami-0036b4598ccd42565"
        ohiho = "ami-0d50e5e845c552faf"

    }
}

variable "instance_type_list" {
    default = ["t2 micro" ,"t2 small","t2 medium"]
}
