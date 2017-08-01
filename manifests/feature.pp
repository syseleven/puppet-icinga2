# == Define: icinga2::feature
#
# Private define resource to used by this module only.
#
#
define icinga2::feature(
  Enum['absent', 'present'] $ensure  = present,
  String                    $feature = $title,
) {

  assert_private()

  if ! defined(Class['::icinga2']) {
    fail('You must include the icinga2 base class before using any icinga2 feature class!')
  }

  $user     = $::icinga2::params::user
  $group    = $::icinga2::params::group
  $conf_dir = $::icinga2::params::conf_dir

  if $::osfamily != 'windows' {
    $_ensure = $ensure ? {
      'present' => link,
      default   => absent,
    }

    file { "${conf_dir}/features-enabled/${feature}.conf":
      ensure  => $_ensure,
      owner   => $user,
      group   => $group,
      target  => "../features-available/${feature}.conf",
      require => Concat["${conf_dir}/features-available/${feature}.conf"],
      notify  => Class['::icinga2::service'],
    }
  } else {
    $_ensure = $ensure ? {
      'present' => file,
      default   => absent,
    }

    file { "${conf_dir}/features-enabled/${feature}.conf":
      ensure  => $_ensure,
      owner   => $user,
      group   => $group,
      content => "include \"../features-available/${feature}.conf\"\r\n",
      require => Concat["${conf_dir}/features-available/${feature}.conf"],
      notify  => Class['::icinga2::service'],
    }
  }

}
