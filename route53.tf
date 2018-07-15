resource "aws_route53_record" "zookeeper" {
  count   = "${var.instance-count}"
  zone_id = "${data.aws_route53_zone.main-domain.zone_id}"
  name    = "${element(data.template_file.userdata.*.vars.zookeeper_hostname,count.index)}"
  type    = "A"
  ttl     = "300"
  records = ["${element(aws_instance.nodes.*.private_ip,count.index)}"]
}

resource "aws_route53_record" "kafka" {
  count   = "${var.instance-count}"
  zone_id = "${data.aws_route53_zone.main-domain.zone_id}"
  name    = "${element(data.template_file.userdata.*.vars.hostname,count.index)}"
  type    = "A"
  ttl     = "300"
  records = ["${element(aws_instance.nodes.*.private_ip,count.index)}"]
}
