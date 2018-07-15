output "zookeeper-hostnames" {
  value = ["${aws_route53_record.zookeeper.*.fqdn}"]
}

output "kafka-hostnames" {
  value = ["${aws_route53_record.kafka.*.fqdn}"]
}

output "kafka-manager-url" {
  value = ["http://${aws_route53_record.kafka.0.fqdn}:8080"]
}

output "zookeeper-connect" {
  value = ["${local.zookeeper-connect}"]
}
