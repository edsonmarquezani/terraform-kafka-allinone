node default {
  include common
  include kafka
  include zookeeper
}

node /^.*-1$/ {
  include common
  include kafka
  include zookeeper
  if "${::kafka_manager}" == "1" {
    include kafka_manager
  }
}
