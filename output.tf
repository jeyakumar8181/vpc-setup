output "vcp_id" {
  value = "${aws_vpc.jai_terr_vpc.id}"
}

output "privatesubnet_id" {
  value = "${aws_subnet.privatesubnet.id}"
}

output "publicsubnet_id" {
  value = "${aws_subnet.publicsubnet.id}"
}
