variable "instance_ami" {
    type        = string
    description = "this is ami of instance"
    default     = "ami-0036b4598ccd42565"
  
}

variable "instance_type" {
    type        =  list(any)
    description = "instance type for the instance"
    default     = ["t2.micro", "t2.medium","t2.large","t3.micro"]
      
}
    
variable "instance_tags" {
 type        = map(any)
 description = "tag for instance"
 default = {
   owner = "shubhamvsathawane@gmail.com"
   purpose = "terraform learning"
   enddate = "10/02/2023"
    }
}

variable "availability_zone" {
  type        = string
  description = "availability zone"
  default     = "us-west-1c"

}

variable "key_name" {
  type        = string
  description = "key name"
  default     = "n.california"
  
}

variable "monitoring" {
  type        = bool
  description = "monitoring"
  default     = false

}

variable "sg_name" {    
  type        = string
  description = "security group"
  default     = "tf_security_group"
}

variable "sg_description" {
  type         = string
  description  = "security group descriprtion"
  default      = "security group discription"
}


  
