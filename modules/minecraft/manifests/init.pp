class minecraft {

  file { '/opt/minecraft':
    ensure => directory,
  }

  package { 'java-11-openjdk-devel':
    ensure => installed,
  }

  exec { 'download_minecraft_server':
    command     => 'wget https://piston-data.mojang.com/v1/objects/84194a2f286ef7c14ed7ce0090dba59902951553/server.jar -O minecraft_server.jar',
    cwd         => '/opt/minecraft',
    refreshonly => true,
  }

  exec { 'install_minecraft_server':
    command     => 'java -Xmx1024M -Xms1024M -jar minecraft_server.jar nogui',
    cwd         => '/opt/minecraft',
    creates     => '/opt/minecraft/server.properties',
    refreshonly => true,
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
