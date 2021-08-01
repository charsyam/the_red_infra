resource "aws_lb" "geoip_lb" {
  name               = "geoip-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_the_red.id]
  subnets            = data.aws_subnet_ids.all.ids

  enable_deletion_protection = false

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_target_group" "geoip_lb_target_group" {
  name     = "geoip-lb-tg"
  port     = 7002
  protocol = "HTTP"
  vpc_id   = "${data.aws_vpc.default.id}"


  health_check {
    interval            = 30
    path                = "/health_check"
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_listener" "geoip_lb" {
  load_balancer_arn = aws_lb.geoip_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.geoip_lb_target_group.arn
  }
}
