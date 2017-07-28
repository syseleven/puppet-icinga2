# == Define: icinga2::object::apiuser
#
# Manage Icinga 2 ApiUser objects.
#
# === Parameters
#
# [*ensure*]
#   Set to present enables the object, absent disables it. Defaults to present.
#
# [*apiuser_name*]
#   Set the name of the apiuser object. Defaults to title of the define resource.
#
# [*password*]
#   Password string.
#
# [*client_cn*]
#   Optional. Client Common Name (CN).
#
# [*permissions*]
#   Array of permissions. Either as string or dictionary with the keys permission
#   and filter. The latter must be specified as function.
#
# [*target*]
#   Destination config file to store in this object. File will be declared at the
#   first time.
#
# [*order*]
#   String to set the position in the target file, sorted alpha numeric. Defaults to 10.
#
# === Examples
#
# permissions = [ "*" ]
#
# permissions = [ "objects/query/Host", "objects/query/Service" ]
#
# permissions = [
#   {
#     permission = "objects/query/Host"
#     filter = {{ regex("^Linux", host.vars.os) }}
#   },
#   {
#     permission = "objects/query/Service"
#     filter = {{ regex("^Linux", service.vars.os) }}
#   }
# ]
#
#
define icinga2::object::apiuser(
  Stdlib::Absolutepath      $target,
  Array                     $permissions,
  Enum['present', 'absent'] $ensure       = present,
  String                    $apiuser_name = $title,
  Optional[String]          $password     = undef,
  Optional[String]          $client_cn    = undef,
  Pattern[/^\d+$/]          $order        = '30',
) {

  # compose the attributes
  $attrs = {
    password    => $password,
    client_cn   => $client_cn,
    permissions => $permissions,
  }

  # create object
  icinga2::object { "icinga2::object::ApiUser::${title}":
    ensure      => $ensure,
    object_name => $apiuser_name,
    object_type => 'ApiUser',
    attrs       => delete_undef_values($attrs),
    attrs_list  => keys($attrs),
    target      => $target,
    order       => $order,
    notify      => Class['::icinga2::service'],
  }
}
