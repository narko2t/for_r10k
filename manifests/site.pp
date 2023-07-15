node 'slave1.puppet' {

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
  }

  service { 'httpd':
    ensure => running,
    enable => true,
  }
}

node 'slave2.puppet' {

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
          ErrorLog /var/log/httpd/php_error.log
          CustomLog /var/log/httpd/php_access.log combined 
        </Directory>
      </VirtualHost>",
  }

  service { 'httpd':
    ensure => running,
    enable => true,
  }
}

node 'master.puppet' {
  include nginx

  nginx::resource::location{'/static':
    proxy => '192.168.21.11' ,
  }
  nginx::resource::location{'/dinamic':
    proxy => '192.168.21.12' ,
  }
}
