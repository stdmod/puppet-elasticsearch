# Class: elasticsearch::user
#
# This class creates elasticsearch user
#
class elasticsearch::user {
  @user { $elasticsearch::user :
    ensure     => $elasticsearch::manage_file,
    comment    => "${elasticsearch::user} user",
    password   => '!',
    managehome => false,
    uid        => $elasticsearch::user_uid,
    gid        => $elasticsearch::user_gid,
    groups     => $elasticsearch::groups,
    shell      => '/bin/bash',
  }

  User <| title == $elasticsearch::user |>

}

