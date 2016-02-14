#!/bin/sh

# Wait for the RDF Store
until [ "`curl --silent --show-error --connect-timeout 1 -I http://${RDFSTORE_HOST}:${RDFSTORE_PORT} | grep '200 OK'`" != "" ];
do
  echo "--- sleeping for 5 seconds"
  sleep 5
done

echo "RDF Store listening"

# Setup the store 
if [ ! -f ${ISERVE_DATA}/.repository_created ]; then
    case "${RDFSTORE_TYPE}" in
      ("sesame") 
          ${ISERVE_BASE}/scripts/setup-sesame.sh ${RDFSTORE_HOST} ${RDFSTORE_PORT} ;;
      ("owlim") 
          ${ISERVE_BASE}/scripts/setup-owlim.sh ${RDFSTORE_HOST} ${RDFSTORE_PORT} ;;
      ("fuseki") 
          echo "Using fuseki. Already setup." ;;
      (*) 
          echo "${RDFSTORE_TYPE} is an unknown RDF store. Configure manually."
          exit 1 ;;
    esac
    
	echo "Repository created"
    mkdir -p ${ISERVE_DATA}
	touch ${ISERVE_DATA}/.repository_created
fi

## Setup and Run iServe

if [ ! -f /.tomcat_admin_created ]; then
    /create_tomcat_admin_user.sh
fi

# Create config folder if necessary
if [ ! -d "${ISERVE_DATA}/conf" ]; then
    mkdir -p ${ISERVE_DATA}/conf
fi

# Setup Log4j if necessary 
if [ ! -f "${ISERVE_DATA}/conf/logback.xml" ]; then
  cp ${ISERVE_BASE}/conf/logback.xml ${ISERVE_DATA}/conf/
fi

# Setup ELDA Configuration if necessary 
if [ ! -f "${ISERVE_DATA}/conf/elda-spec-iserve.ttl" ]; then
  # Generate ELDA config
  ${ISERVE_BASE}/scripts/generate-elda-config.sh ${ISERVE_HOST} ${ISERVE_PORT} ${ISERVE_APP_NAME} ${RDFSTORE_HOST} ${RDFSTORE_PORT} ${ISERVE_REPOSITORY} ${RDFSTORE_TYPE} 
  echo "iServe GUI configuration created"
  cp ${ISERVE_BASE}/scripts/elda-spec-iserve.ttl ${ISERVE_DATA}/conf/
fi

# Setup iServe Configuration if necessary 
if [ ! -f "${ISERVE_DATA}/conf/config.properties.env" ]; then
  # Generate iServe config
  ${ISERVE_BASE}/scripts/generate-iserve-config.sh ${ISERVE_HOST} ${ISERVE_PORT} ${ISERVE_APP_NAME} ${RDFSTORE_HOST} ${RDFSTORE_PORT} ${ISERVE_REPOSITORY} ${RDFSTORE_TYPE} 
  echo "iServe configuration created"
  cp ${ISERVE_BASE}/scripts/config.properties.env ${ISERVE_DATA}/conf/
fi

export JAVA_OPTS="$JAVA_OPTS -Duser.language=en"
export CATALINA_PID=${CATALINA_HOME}/temp/tomcat.pid
export CATALINA_OPTS="$CATALINA_OPTS ${JVM_ARGS} -Djava.security.egd=file:/dev/./urandom"

exec ${CATALINA_HOME}/bin/catalina.sh run

