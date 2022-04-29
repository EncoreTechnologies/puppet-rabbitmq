# Makes sure that the Packagecloud repo is installed
#
# @api private
class rabbitmq::repo::rhel (
  $location          = "https://packagecloud.io/rabbitmq/rabbitmq-server/el/${facts['os'][release][major]}/\$basearch",
  String $key_source = $rabbitmq::package_gpg_key,
  String $rabbitmq_key_source = 'https://github.com/rabbitmq/signing-keys/releases/download/2.0/rabbitmq-release-signing-key.asc',
) {
  # This may still be needed to prevent warnings
  # packagecloud key is gpg-pubkey-4d206f89-5bbb8d59
  exec { "rpm --import ${rabbitmq_key_source}":
    path   => ['/bin','/usr/bin','/sbin','/usr/sbin'],
    unless => 'rpm -q gpg-pubkey-6026dfca-573adfde 2>/dev/null',
    before => YumRepo['rabbitmq'],
  }

  yumrepo { 'rabbitmq':
    ensure        => present,
    name          => 'rabbitmq_rabbitmq-server',
    baseurl       => $location,
    gpgkey        => $key_source,
    enabled       => 1,
    gpgcheck      => 1,
    repo_gpgcheck => 1,
  }

  # This may still be needed to prevent warnings
  # packagecloud key is gpg-pubkey-4d206f89-5bbb8d59
  exec { "rpm --import ${key_source}":
    path   => ['/bin','/usr/bin','/sbin','/usr/sbin'],
    unless => 'rpm -q gpg-pubkey-4d206f89-5bbb8d59 2>/dev/null',
    require => YumRepo['rabbitmq'],
  }
}
