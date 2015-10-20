#!/bin/bash

if [ ! -f /.tomcat_admin_created ]; then
    /create_tomcat_admin_user.sh
fi

# Setup elda-spec
${ISERVE_BASE}/scripts/generate-elda-config.sh ${ISERVE_HOST} ${ISERVE_PORT} ${ISERVE_APP_NAME} ${RDFSTORE_HOST} ${RDFSTORE_PORT} ${ISERVE_REPOSITORY} ${RDFSTORE_TYPE} 
echo "iServe GUI configuration created"
cp ${ISERVE_BASE}/scripts/elda-spec-iserve.ttl ${ISERVE_DATA}/conf

export JAVA_OPTS="$JAVA_OPTS -Duser.language=en"
export CATALINA_PID=${CATALINA_HOME}/temp/tomcat.pid
export CATALINA_OPTS="$CATALINA_OPTS ${JVM_ARGS} -Djava.security.egd=file:/dev/./urandom"

exec ${CATALINA_HOME}/bin/catalina.sh run