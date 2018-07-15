data "template_file" "zoo-servers" {
  count = "${var.instance-count}"

  vars {
    part = "server.${count.index+1}=${element(data.template_file.userdata.*.vars.zookeeper_hostname,count.index)}:2888:3888"
  }
}

locals {
  setup-files-path  = "/tmp"
  zookeeper-connect = "${format("%s/%s", join(",", formatlist("%s:2181",data.template_file.userdata.*.vars.zookeeper_hostname)), local.kafka-name-prefix)}"
  zoo-servers       = "${join(" ", data.template_file.zoo-servers.*.vars.part)}"

  default_tags = {
    environment = "${var.environment}"
  }

  tags = "${merge(local.default_tags,var.tags)}"

  kafka-name-prefix = "${var.instances-name-prefix}"
  kafka-dns-prefix  = "${ var.kafka-dns-prefix == "" ?  "${var.instances-name-prefix}" : var.kafka-dns-prefix}"

  zookeeper-name-prefix = "${var.instances-name-prefix}-zookeeper"
  zookeeper-dns-prefix  = "${ var.zookeeper-dns-prefix == "" ?  "${local.zookeeper-name-prefix}" : var.zookeeper-dns-prefix}"
  zookeeper-ports       = [2181, 2888, 3888]

  kafka-ports        = [1099, 9092]
  kafka-manager-port = 8080

  admin-user = "centos"

  private-cidrs = [
    "10.0.0.0/8",
    "172.16.0.0/12",
    "192.168.0.0/16",
  ]
}
