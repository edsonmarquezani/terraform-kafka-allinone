class kafka {

  $kafka_uid = 5000
  $kafka_gid = 5000
  $id = regsubst($hostname, '^.*-(\d+)$','\1')

  group {
    'kafka':
      ensure => present,
      gid    => "${kafka_gid}",
  }

  user {
    'kafka':
      ensure  => present,
      uid     => "${kafka_uid}",
      gid     => "${kafka_gid}",
      require => Group['kafka'],
  }

  file {
    ['/mnt/data/kafka',
     '/mnt/data/logs' ]:
      ensure  => directory,
      owner   => "${kafka_uid}",
      group   => "${kafka_gid}",
      mode    => '0775',
      require => Mount['/mnt/data'];

    '/etc/systemd/system/kafka.service':
      ensure  => present,
      source  => "${::basepath}/modules/kafka/files/kafka.service",
      notify  => [ Service['kafka.service'],
                    Exec['daemon-reload'] ];

    '/etc/sysconfig/kafka':
      ensure  => present,
      content => "KAFKA_BROKER_ID=${id}",
      notify  => Service['kafka.service'];
  }

  service {
    'kafka.service':
      ensure  => running,
      enable  => true,
      require => [ File['/etc/systemd/system/kafka.service',
                        '/mnt/data/kafka',
                        '/root/.docker/config.json',
                        '/etc/sysconfig/netvars']
                  ],
  }

  Exec <| title == 'daemon-reload' |> {
    before +> Service['kafka.service']
  }
}
