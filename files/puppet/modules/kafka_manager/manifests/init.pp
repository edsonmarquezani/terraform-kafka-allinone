class kafka_manager {

  file {
    '/etc/systemd/system/kafka-manager.service':
      ensure => present,
      source => "${::basepath}/modules/kafka_manager/files/kafka-manager.service",
      notify => [ Service['kafka-manager.service'],
                  Exec['daemon-reload'] ]
  }

  service {
    'kafka-manager.service':
      ensure  => running,
      enable  => true,
      require => File['/etc/systemd/system/kafka-manager.service']
  }

  Exec <| title == 'daemon-reload' |> {
    before +> Service['kafka-manager.service']
  }
}
