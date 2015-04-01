# On Debian systems, if alternatives are set, manually assign them.
class am_java::config ( ) {
  case $::osfamily {
    'Debian': {
      if $am_java::use_java_alternative != undef and $am_java::use_java_alternative_path != undef {
        exec { 'update-java-alternatives':
          path    => '/usr/bin:/usr/sbin:/bin:/sbin',
          command => "update-java-alternatives --set ${am_java::use_java_alternative} ${am_java::jre_flag}",
          unless  => "test /etc/alternatives/java -ef '${am_java::use_java_alternative_path}'",
        }
      }
    }
    'RedHat': {
      if $am_java::use_java_alternative != undef and $am_java::use_java_alternative_path != undef {
        # The standard packages install alternatives, custom packages do not
        # For the stanard packages java::params needs these added.
        if $am_java::use_java_package_name != $am_java::default_package_name {
          exec { 'create-java-alternatives':
            path    => '/usr/bin:/usr/sbin:/bin:/sbin',
            command => "alternatives --install ${am_java::use_java_alternative} java ${$am_java::use_java_alternative_path} 20000" ,
            unless  => "alternatives --display java | grep -q ${$am_java::use_java_alternative_path}",
            before  => Exec['update-java-alternatives']
          }
        }

        exec { 'update-java-alternatives':
          path    => '/usr/bin:/usr/sbin',
          command => "alternatives --set java ${$am_java::use_java_alternative_path}" ,
          unless  => "test /etc/alternatives/java -ef '${am_java::use_java_alternative_path}'",
        }
      }
    }
    default: {
      # Do nothing.
    }
  }
}
