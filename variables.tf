variable "region" {
  default     = "sa-east-1"
  description = "AWS region"
}

variable "subnets" {
  type        = "list"
  default     = []
  description = "List of subnet IDs where EC2 instances will placed on"
}

variable "azs" {
  type        = "list"
  default     = []
  description = "List of Availability Zones where EC2 instances will placed on. Must match Subnets list"
}

variable "vpc_id" {
  type = "string"
}

variable "instances-name-prefix" {
  default     = "mykafka"
  description = "Name prefix of EC2 instances (used for Name tags and DNS names defaults)"
}

################  Kafka  #################

variable "kafka-version" {
  default     = "1.1.0"
  description = "Kafka version"
}

variable "zookeeper-version" {
  default     = "3.4.12"
  description = "Zookeeper Version"
}

variable "instance-count" {
  default     = "3"
  description = "Number of instances"
}

variable "instance-type" {
  default     = "t2.small"
  description = "EC2 instance type"
}

variable "data-disk-size" {
  default     = "15"
  description = "Size of the data disk (GB)"
}

variable "root-disk-size" {
  default     = "10"
  description = "Size of the root disk (GB)"
}

variable "kafka-heap-size" {
  default     = "512M"
  description = "Size of Kafka's JVM Heap (-Xms and -Xmx) (accepts any unit accepted by JVM - M, G, etc)"
}

variable "zookeeper-heap-size" {
  default     = "512M"
  description = "Size of Zookeepers's JVM Heap (-Xms and -Xmx) (accepts any unit accepted by JVM - M, G, etc)"
}

variable "kafka-dns-prefix" {
  default     = ""
  description = "DNS name prefix for Kafka"
}

variable "zookeeper-dns-prefix" {
  default     = ""
  description = "DNS name prefix for Zookeeper"
}

############ General Settings ############

variable "tags" {
  type        = "map"
  default     = {}
  description = "Additional tags for EC2 instances"
}

variable "disable-api-termination" {
  default     = "true"
  description = "Whether EC2 should or not be protected from termination"
}

variable "ebs-force-dettach" {
  default     = "false"
  description = "Whether EBS disks should force-dettached when terminating EC2 instances"
}

variable "keypair" {
  default     = "toolux"
  description = "EC2 Keypair for SSH Access"
}

variable "domain" {
  default     = ""
  description = "Name of the Route53 zone where DNS records will be created"
}

variable "allowed-networks" {
  type        = "list"
  description = "List of CIDR blocks which will be allowed access to Kafka"
}

variable "puppet-files-path" {
  default     = ""
  description = "Optional alternative path for Puppet manifests to be used instead of module's version of it"
}

variable "install-kafka-manager" {
  default     = true
  description = "Whether Kafka Manager should or not be installed"
}
