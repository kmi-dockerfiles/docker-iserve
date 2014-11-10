#!/bin/sh

# Wait for it
until [ "`curl --silent --show-error --connect-timeout 1 -I http://rdfstore:8080 | grep 'Coyote'`" != "" ];
do
  echo "--- sleeping for 10 seconds"
  sleep 10
done

echo "RDF Store listening"

# Setup the store 
if [ ! -f /data/.repository_created ]; then
	$ISERVE_BASE/scripts/setup-sesame.sh rdfstore 8080
	echo "Repository created"
	touch /data/.repository_created
fi

# Setup elda-spec
$ISERVE_BASE/scripts/generate-elda-config.sh ${ISERVE_HOST} ${ISERVE_PORT} ${ISERVE_APP_NAME} rdfstore 8080 ${ISERVE_REPOSITORY} ${RDFSTORE_TYPE} 

cp $ISERVE_BASE/scripts/elda-spec-iserve.ttl $ISERVE_BASE/conf

if [ ! -f /.tomcat_admin_created ]; then
    /create_tomcat_admin_user.sh
fi

export JAVA_OPTS="$JAVA_OPTS -Duser.language=en"
export CATALINA_PID=${CATALINA_HOME}/temp/tomcat.pid
export CATALINA_OPTS="$CATALINA_OPTS -Xmx${JAVA_MAXMEMORY}m -Djava.security.egd=file:/dev/./urandom"

exec ${CATALINA_HOME}/bin/catalina.sh run

