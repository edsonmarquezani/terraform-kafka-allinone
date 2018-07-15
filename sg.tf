################################## kafka ##################################

resource "aws_security_group" "kafka" {
  name        = "${local.kafka-name-prefix}"
  description = "Allow kafka inbound traffic"
  vpc_id      = "${var.vpc_id}"
  tags        = "${local.tags}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "kafka-egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.kafka.id}"
}

resource "aws_security_group_rule" "kafka-ingress" {
  count             = "${length(concat(local.kafka-ports,local.zookeeper-ports))}"
  type              = "ingress"
  from_port         = "${element(concat(local.kafka-ports,local.zookeeper-ports),count.index)}"
  to_port           = "${element(concat(local.kafka-ports,local.zookeeper-ports),count.index)}"
  protocol          = "tcp"
  cidr_blocks       = ["${var.allowed-networks}"]
  security_group_id = "${aws_security_group.kafka.id}"
}

resource "aws_security_group_rule" "kafka-ingress-self" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  security_group_id = "${aws_security_group.kafka.id}"
  self              = true
}

resource "aws_security_group_rule" "kafka-ssh-ingress" {
  type              = "ingress"
  from_port         = "22"
  to_port           = "22"
  protocol          = "tcp"
  cidr_blocks       = ["${local.private-cidrs}"]
  security_group_id = "${aws_security_group.kafka.id}"
}

resource "aws_security_group_rule" "kafka-manager-ingress" {
  type              = "ingress"
  from_port         = "${local.kafka-manager-port}"
  to_port           = "${local.kafka-manager-port}"
  protocol          = "tcp"
  cidr_blocks       = ["${local.private-cidrs}"]
  security_group_id = "${aws_security_group.kafka.id}"
}
