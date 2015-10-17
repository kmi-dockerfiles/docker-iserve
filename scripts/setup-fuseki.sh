#!/bin/bash
#   Licensed to the Apache Software Foundation (ASF) under one or more
#   contributor license agreements.  See the NOTICE file distributed with
#   this work for additional information regarding copyright ownership.
#   The ASF licenses this file to You under the Apache License, Version 2.0
#   (the "License"); you may not use this file except in compliance with
#   the License.  You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

set -e

if [ ! -f "$FUSEKI_BASE/config.ttl" ] ; then
  # First time
  echo "###################################"
  echo "Initializing Apache Jena Fuseki"
  echo ""
  
  # Let's skip passwords
  #
  # cp "$FUSEKI_HOME/shiro.ini" "$FUSEKI_BASE/shiro.ini"
  # if [ -z "$ADMIN_PASSWORD" ] ; then
  #   ADMIN_PASSWORD=$(pwgen -s 15)
  #   echo "Randomly generated admin password:"
  #   echo ""
  #   echo "admin=$ADMIN_PASSWORD"
  # fi
  
  CONFIG=/opt/scripts/repositories-config/iserve-fuseki-v2.ttl
  CONFIG_SVC=/opt/scripts/repositories-config/iserve_text_tdb.ttl
  
  mkdir $FUSEKI_BASE/configuration 
  cp $CONFIG $FUSEKI_BASE/config.ttl
  echo "Copied $CONFIG to $FUSEKI_BASE"  

  cp $CONFIG_SVC $FUSEKI_BASE/configuration
  echo "Copied $CONFIG_SVC to $FUSEKI_BASE/configuration"
  
  echo ""
  echo "###################################"
fi

# Let's skip passwords
#
# $ADMIN_PASSWORD can always override
# if [ -n "$ADMIN_PASSWORD" ] ; then
#   sed -i "s/^admin=.*/admin=$ADMIN_PASSWORD/" "$FUSEKI_BASE/shiro.ini"
# fi

#exec "$1"

exec /jena-fuseki/fuseki-server


