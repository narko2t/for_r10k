class minecraft {

  file { '/opt/minecraft':
    ensure => directory,
  }

  package { 'java-11-openjdk-devel':
    ensure => installed,
  }

  file { '/opt/minecraft/minecraft_server.1.20.1.jar':
  ensure => present,
  source => 'https://piston-data.mojang.com/v1/objects/84194a2f286ef7c14ed7ce0090dba59902951553/server.jar',

  file { '/opt/minecraft/server.properties':
    ensure => file,
  }
  
  file { '/etc/systemd/system/minecraft.service':
    source => "puppet:///modules/minecraft/minecraft.service",
    notify  => Service['minecraft'],
  }

  service { 'minecraft':
    ensure    => running,
    enable    => true,
  }
}
