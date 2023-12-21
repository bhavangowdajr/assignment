resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"
}
resource "aws_subnet" "Public_sub1" {
  cidr_block = "10.0.0.0/24"
  vpc_id = "${aws_vpc.myvpc.id}"
}
resource "aws_subnet" "public_sub2" {
  cidr_block = "10.0.1.0/24"
  vpc_id = "${aws_vpc.myvpc.id}"
}
resource "aws_subnet" "private_sub1" {
  cidr_block = "10.0.2.0/24"
  vpc_id = "${aws_vpc.myvpc.id}"
}
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.myvpc.id}"
  tags = {
    Name = "mygw"
  }
}
resource "aws_route_table" "RTFP" {
  vpc_id = "${aws_vpc.myvpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }
  tags = {
    Name = "bhavan-route"
  }
}
resource "aws_route_table_association" "subass1" {
  subnet_id = "${aws_subnet.Public_sub1.id}"
  route_table_id = "${aws_route_table.RTFP.id}"
}
output "movpc" {
  value = "${aws_vpc.myvpc.id}"
}
output "mosub" {
  value = "${aws_subnet.Public_sub1.id}"
}

