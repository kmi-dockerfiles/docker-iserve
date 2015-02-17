FROM tutum/tomcat:7.0

MAINTAINER Carlos Pedrinaci "carlos.pedrinaci@open.ac.uk"

ENV ISERVE_VERSION 2.0.0-RC3

ENV ISERVE_APP_NAME iserve
ENV ISERVE_BASE /data/iserve

# Container setup

ENV ISERVE_HOST localhost
ENV ISERVE_PORT 8080
ENV CATALINA_BASE /tomcat
ENV JAVA_MAXMEMORY 1024
# Setup accordingly the env variables below
ENV RDFSTORE_HOST localhost
ENV RDFSTORE_PORT 9090
ENV RDFSTORE_TYPE sesame

ENV JAVA_OPTS -Dlog4j.configuration=file:/opt/iserve/conf/log4j.properties -Delda.spec=/opt/iserve/conf/elda-spec-iserve.ttl -Diserve.config=/opt/iserve/conf/config.properties.env 

# Install CURL
RUN apt-get update && apt-get install -y curl && apt-get clean

# Remove docs and examples & deploy
RUN rm -rf ${CATALINA_BASE}/webapps/docs && rm -rf ${CATALINA_BASE}/webapps/examples && wget https://github.com/kmi/iserve/releases/download/v${ISERVE_VERSION}/iserve-webapp-${ISERVE_VERSION}.war -O ${CATALINA_BASE}/webapps/${ISERVE_APP_NAME}.war

# Setup iServe
COPY ./conf/ /opt/iserve/conf/
COPY ./scripts/ /opt/iserve/scripts/
RUN chmod +x /opt/iserve/scripts/*.sh

COPY run.sh /run.sh

CMD ["/run.sh"]