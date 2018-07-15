data "template_file" "userdata" {
  count    = "${var.instance-count}"
  template = "${file("${path.module}/files/cloud-init.tpl")}"

  vars {
    domain                = "${var.domain}"
    hostname              = "${local.kafka-dns-prefix}-${count.index+1}.${var.domain}"
    zookeeper_hostname    = "${local.zookeeper-dns-prefix}-${count.index+1}.${var.domain}"
    install-kafka-manager = "${var.install-kafka-manager}"
  }
}

resource "aws_ebs_volume" "data" {
  count             = "${var.instance-count}"
  availability_zone = "${element(var.azs,count.index)}"
  size              = "${var.data-disk-size}"
  type              = "gp2"

  tags = "${merge(local.tags,
            map("Name", "${local.kafka-name-prefix}-${count.index+1}-data"))}"
}

resource "aws_instance" "nodes" {
  count = "${var.instance-count}"

  ami                     = "${data.aws_ami.centos7.id}"
  instance_type           = "${var.instance-type}"
  subnet_id               = "${element(var.subnets,count.index)}"
  iam_instance_profile    = "${aws_iam_instance_profile.kafka.name}"
  disable_api_termination = "${var.disable-api-termination}"
  vpc_security_group_ids  = ["${aws_security_group.kafka.id}"]
  key_name                = "${var.keypair}"
  user_data               = "${element(data.template_file.userdata.*.rendered,count.index)}"

  root_block_device {
    volume_type = "gp2"
    volume_size = "${var.root-disk-size}"
  }

  tags = "${merge(local.tags,
            map("Name", "${local.kafka-name-prefix}-${count.index+1}"))}"

  lifecycle {
    ignore_changes = ["ami", "user_data"]
  }
}

resource "aws_volume_attachment" "data" {
  count       = "${var.instance-count}"
  device_name = "/dev/sdf"
  volume_id   = "${element(aws_ebs_volume.data.*.id, count.index)}"
  instance_id = "${element(aws_instance.nodes.*.id, count.index)}"

  lifecycle {
    ignore_changes = ["volume_id", "instance_id"]
  }

  force_detach = "${var.ebs-force-dettach}"
}
