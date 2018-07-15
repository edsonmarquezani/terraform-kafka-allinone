locals {
  files-path = "${var.puppet-files-path == "" ? "${path.module}/files" : var.puppet-files-path}"
}

data "template_file" "terraform-vars" {
  template = "${file("${path.module}/files/terraform-vars.tpl")}"

  vars {
    kafka-name-prefix     = "${local.kafka-name-prefix}"
    kafka-heap-size       = "${var.kafka-heap-size}"
    kafka-version         = "${var.kafka-version}"
    zookeeper-name-prefix = "${local.zookeeper-name-prefix}"
    zookeeper-heap-size   = "${var.zookeeper-heap-size}"
    zookeeper-connect     = "${local.zookeeper-connect}"
    zookeeper-version     = "${var.zookeeper-version}"
    zoo-servers           = "${local.zoo-servers}"
  }
}

resource "null_resource" "setup-common" {
  count = "${var.instance-count}"

  connection {
    host = "${element(aws_instance.nodes.*.private_ip,count.index)}"
    user = "${local.admin-user}"
  }

  provisioner "file" {
    source      = "${local.files-path}/scripts"
    destination = "${local.setup-files-path}"
  }

  provisioner "file" {
    content     = "${data.template_file.terraform-vars.rendered}"
    destination = "/tmp/terraform-vars"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo cp /tmp/terraform-vars /etc/sysconfig/terraform-vars",
      "sudo bash -x ${local.setup-files-path}/scripts/puppet-setup.sh",
    ]
  }
}

resource "null_resource" "puppet-apply" {
  count      = "${var.instance-count}"
  depends_on = ["null_resource.setup-common"]

  connection {
    host = "${element(aws_instance.nodes.*.private_ip,count.index)}"
    user = "${local.admin-user}"
  }

  provisioner "file" {
    source      = "${local.files-path}/scripts"
    destination = "${local.setup-files-path}"
  }

  provisioner "file" {
    source      = "${local.files-path}/puppet"
    destination = "${local.setup-files-path}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo bash -x ${local.setup-files-path}/scripts/puppet-apply.sh ${local.setup-files-path}/puppet",
      "sudo rm -rf /tmp/scripts && sudo rm -rf /tmp/puppet",
    ]
  }
}
