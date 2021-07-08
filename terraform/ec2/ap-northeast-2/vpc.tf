data "aws_vpc" "default" {
  default = true
}

data "aws_subnet" "default" {
  vpc_id            = "${data.aws_vpc.default.id}"
  default_for_az    = true
  availability_zone = "${var.availability_zone}"
}

data "aws_subnet_ids" "all" {
  vpc_id = "${data.aws_vpc.vpc.id}"
}

data "aws_vpc" "vpc" {
  id = "${data.aws_vpc.default.id}"
}

data "aws_subnet" "subnet" {
  id = "${data.aws_subnet.default.id}"
}
