#!/bin/bash

if [ ! -f /.tomcat_admin_created ]; then
    /create_tomcat_admin_user.sh
fi

export JAVA_OPTS="$JAVA_OPTS -Duser.language=en"
export CATALINA_PID=${CATALINA_HOME}/temp/tomcat.pid
export CATALINA_OPTS="$CATALINA_OPTS -Xmx${JAVA_MAXMEMORY}m -Djava.security.egd=file:/dev/./urandom"

exec ${CATALINA_HOME}/bin/catalina.sh run