resource "aws_iam_role" "kafka" {
  name               = "${local.kafka-name-prefix}"
  assume_role_policy = "${file("${path.module}/iam/ec2-assume-role-policy.json")}"
}

resource "aws_iam_instance_profile" "kafka" {
  name = "${local.kafka-name-prefix}"
  role = "${aws_iam_role.kafka.name}"
}
