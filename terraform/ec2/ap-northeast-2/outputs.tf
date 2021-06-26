output "instances" {
  description = "List of instance IDs"
  value       = ["${aws_spot_instance_request.instance.*.spot_instance_id}"]
}

output "public_ips" {
  description = "List of public ip addresses created by this module"
  value       = ["${aws_spot_instance_request.instance.*.public_ip}"]
}

output "private_ips" {
  description = "List of private ip addresses created by this module"
  value       = ["${aws_spot_instance_request.instance.*.private_ip}"]
}
