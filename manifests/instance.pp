class am_java::instance (
  $am_java_instances = {
    # these values you will see as default in your ENC like The Foreman
       package               => 'oracle-java7-installer',
  },
  $am_java_instances_defaults = {
      distribution => 'jdk',
      version      => 'latest',
      package               => 'jdk-8u25-linux-x64',
      java_alternative      => 'jdk1.8.0_25',
      java_alternative_path => '/usr/java/jdk1.8.0_25/jre/bin/java'
  },
) {

  # load tomcat default stuff like system user, group, etc
  require am_java

  # call tomcats::install define to configure each tomcat instance
  create_resources(am_java, $am_java_instances, $am_java_instances_defaults)
}
