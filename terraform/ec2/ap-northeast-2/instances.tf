resource "aws_spot_instance_request" "instances" {
  instance_type = "${var.instance_type}"
  ami           = "${var.ami}"
  //ami           = "ami-04876f29fd3a5e8ba"

  count                       = "${var.num}"
  associate_public_ip_address = "${var.associate_public_ip_address}"
  vpc_security_group_ids      = ["${aws_security_group.allow_the_red.id}"]
  iam_instance_profile        = "${var.iam_instance_profile}"
  key_name                    = "${var.key_name}"
  availability_zone           = "${var.availability_zone}"

  root_block_device {
    volume_size           = "${var.root_volume_size}"
    volume_type           = "${var.root_volume_type}"
    delete_on_termination = true
  }

  //spot stuff
  block_duration_minutes = 120
  wait_for_fulfillment   = true
  spot_type              = "one-time"
  user_data = ""

  timeouts {
    create = "20m"
  }
}

//from terraform 0.12.x
resource "aws_lb_target_group_attachment" "geoip_attachement" {
  count            = length(aws_spot_instance_request.instances)
  target_group_arn = aws_lb_target_group.geoip_lb_target_group.arn
  target_id        = aws_spot_instance_request.instances[count.index].spot_instance_id
  port             = "${var.geoip_port}"
}
