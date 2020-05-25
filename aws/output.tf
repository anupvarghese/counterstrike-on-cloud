
output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}
output "public_subnets" {
  value = ["${aws_subnet.subnet_public.id}"]
}
output "public_route_table_ids" {
  value = ["${aws_route_table.route_table_public.id}"]
}
output "public_instance_ip" {
  value = ["${aws_instance.csserver.public_ip}"]
}