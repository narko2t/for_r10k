node 'slave1' {

  package { 'httpd':
    ensure => installed,
  }

  file { '/var/www/html/index.html':
    ensure  => file,
    source  => '/home/vagrant/index.html',
  }

  file { '/etc/httpd/conf.d/static.conf':
    ensure  => file,
    content => "
      <VirtualHost *:80>
        DocumentRoot /var/www/html
      </VirtualHost>",
    require => Package['httpd'],
  }

  service { 'httpd':
    ensure => running,
    enable => true,
  }
}

node 'slave2' {

  package { 'httpd':
    ensure => installed,
  }

  package { 'php':
    ensure => installed,
  }

  file { '/var/www/html/index.php':
    ensure  => file,
    source  => '/home/vagrant/index.php',
  }

  file { '/etc/httpd/conf.d/dinamic.conf':
    ensure  => file,
    content => "
      <VirtualHost *:80>
        DocumentRoot /var/www/html
        <Directory /var/www/html>
          Options Indexes FollowSymLinks
          AllowOverride All
          Require all granted
        </Directory>
        <FilesMatch \.php$>
          SetHandler application/x-httpd-php
        </FilesMatch>
      </VirtualHost>",
  }

  service { 'httpd':
    ensure => running,
    enable => true,
  }
}
