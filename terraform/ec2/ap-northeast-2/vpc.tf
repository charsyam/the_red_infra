resource "aws_default_vpc" "default" {}

data "aws_vpc" "default" {
  default = true
}

#vpc id 는 aws 콘솔에서 확인이 가능합니다.
#data "aws_vpc" "default" {
#  id = "{여기에 생성하신 vpc_id 를 입력해주시면 됩니다.}"
#}

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
