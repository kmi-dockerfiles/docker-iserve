FROM tutum/tomcat:7.0

MAINTAINER Carlos Pedrinaci "carlos.pedrinaci@open.ac.uk"

ENV ISERVE_VERSION 2.0.1

ENV ISERVE_APP_NAME iserve
ENV ISERVE_BASE /opt/iserve
ENV ISERVE_DATA /iserve

# Container setup

ENV ISERVE_REPOSITORY iserve
ENV ISERVE_HOST localhost
ENV ISERVE_PORT 8080
ENV CATALINA_BASE /tomcat
ENV JVM_ARGS -Xmx2g

# Setup accordingly the env variables below
ENV RDFSTORE_HOST localhost
ENV RDFSTORE_PORT 9090
ENV RDFSTORE_TYPE sesame

# Redis
ENV REDIS_HOST localhost
ENV REDIS_PORT 6379

ENV JAVA_OPTS -Dlog4j.configuration=file:/iserve/conf/log4j.properties -Delda.spec=/iserve/conf/elda-spec-iserve.ttl -Diserve.config=/iserve/conf/config.properties.env 

# Install CURL
RUN apt-get update && apt-get install -y curl && apt-get clean

# Remove docs and examples & deploy
RUN rm -rf ${CATALINA_BASE}/webapps/docs && rm -rf ${CATALINA_BASE}/webapps/examples && wget https://github.com/kmi/iserve/releases/download/v${ISERVE_VERSION}/iserve-webapp-${ISERVE_VERSION}.war -O ${CATALINA_BASE}/webapps/${ISERVE_APP_NAME}.war

# Setup iServe
COPY ./conf/ /opt/iserve/conf/
COPY ./scripts/ /opt/iserve/scripts/
RUN chmod +x /opt/iserve/scripts/*.sh

COPY run.sh /run.sh

VOLUME /iserve

CMD ["/run.sh"]