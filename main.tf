provider "aws" {
  region = "${var.aws_region}"
}

data "aws_availability_zones" "available" {
}
resource "aws_subnet" "publicsubnet" {
  count = "${var.az_count}"
  vpc_id     = "${aws_vpc.jai_terr_vpc.id}"
  cidr_block = "${cidrsubnet(aws_vpc.jai_terr_vpc.cidr_block, 8,count.index + 1)}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"

  tags {
    Name = "${var.public_subnet_tag1}"
  }
}
resource "aws_vpc" "jai_terr_vpc" {
  cidr_block           = "${var.vpc_cidr_block}"
  tags {
    Name = "vpc-terraform"
  }
}
resource "aws_subnet" "privatesubnet" {
  count = "${var.az_count}"
  vpc_id     = "${aws_vpc.jai_terr_vpc.id}"
  cidr_block = "${cidrsubnet(aws_vpc.jai_terr_vpc.cidr_block, 8,count.index + 10)}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"

  tags {
    Name = "${var.private_subnet_tag1}"
  }
}

resource "aws_eip" "nat_eip"{
vpc = "${var.aws_eip}"
}
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.jai_terr_vpc.id}"

  tags {
    Name = "jaiterraform"
  }
}

resource "aws_nat_gateway" "natgw" {
  allocation_id = "${aws_eip.nat_eip.id}"
  subnet_id     = "${aws_subnet.publicsubnet.0.id}"

}
resource "aws_route_table_association" "route_pvt" {
  subnet_id      = "${element(aws_subnet.privatesubnet.*.id,count.index)}"
  route_table_id = "${aws_route_table.route_private.id}"
}


resource "aws_route_table_association" "route_public" {
  subnet_id      = "${element(aws_subnet.publicsubnet.*.id,count.index)}"
  route_table_id = "${aws_route_table.route_public.id}"
}

resource "aws_route_table" "route_private" {
  vpc_id = "${aws_vpc.jai_terr_vpc.id}"

  route {
    cidr_block = "${var.route_cidr1}"
    gateway_id = "${aws_nat_gateway.natgw.id}"
  }
}

resource "aws_route_table" "route_public" {
  vpc_id = "${aws_vpc.jai_terr_vpc.id}"

  route {
    cidr_block = "${var.route_cidr2}"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }
}


