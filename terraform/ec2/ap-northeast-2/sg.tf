resource "aws_security_group" "allow_the_red" {
  name        = "allow_the_red"
  description = "Allow The Red traffic"
  vpc_id      = "${data.aws_vpc.vpc.id}"

  ingress {
    description      = "My IP"
    from_port 	     = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["${var.my_ip}"]
  }

  ingress {
    description      = "The Red Self"
    from_port 	     = 0
    to_port          = 0
    protocol         = -1
    self             = true
  }

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_the_red"
  }
}
