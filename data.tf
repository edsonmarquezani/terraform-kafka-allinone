data "aws_ami" "centos7" {
  most_recent = true
  name_regex  = "^CentOS Linux 7 x86_64 HVM EBS.*"
  owners      = ["410186602215"]
}

data "aws_route53_zone" "main-domain" {
  name = "${var.domain}"
}
