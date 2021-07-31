output "vpc_id" {
  value = "${data.aws_vpc.vpc.id}"
}

output "subnet_id" {
  value = "${data.aws_subnet.subnet.id}"
}

output "subnet_cidr_block" {
  value = "${data.aws_subnet.subnet.cidr_block}"
}

output "vpc_cidr_block" {
  value = "${data.aws_vpc.vpc.cidr_block}"
}

output "subnet_ids" {
  value = ["${data.aws_subnet_ids.all.ids}"]
}

output "instances" {
  description = "List of instance IDs"
  value       = ["${aws_spot_instance_request.instances.*.spot_instance_id}"]
}

output "public_ips" {
  description = "List of public ip addresses created by this module"
  value       = ["${aws_spot_instance_request.instances.*.public_ip}"]
}

output "private_ips" {
  description = "List of private ip addresses created by this module"
  value       = ["${aws_spot_instance_request.instances.*.private_ip}"]
}

output "geoip_lb_dnsname" {
  description = "aws geoip lb dnsname"
  value       = "${aws_lb.geoip_lb.dns_name}"
}
