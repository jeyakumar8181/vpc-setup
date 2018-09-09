variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "public_subnet_tag1"{
default = "publicsubnet"
}

variable "az_count"{
default = "2"
}

variable "access_key" {}
variable "secret_key" {}
variable "region" {}

variable "private_subnet_tag1"{
default = "privatesubnet"
}

variable "aws_eip"{
        default = "true"
}

variable "route_cidr1"{
  default = "0.0.0.0/0"
}

variable "route_cidr2"{
  default = "0.0.0.0/0"
}
