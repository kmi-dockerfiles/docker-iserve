#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ $# -ne 7 ]; then
    echo "Illegal number of parameters. Usage: `basename $0` iserve-host iserve-port iserve-context rdf-host rdf-port repository-name type"
    echo "Types supported are: sesame, owlim, and fuseki"
    exit 1
fi

SPARQL_QUERY_PATH=$(
  case "$7" in
    ("sesame") echo "openrdf-sesame/repositories/$6" ;;
    ("owlim") echo "openrdf-sesame/repositories/$6" ;;
    ("fuseki") echo "$6/query" ;;
    (*) echo "$7 is an unknown RDF store. Configure manually."
        exit 1;;
  esac)

SPARQL_UPDATE_PATH=$(
  case "$7" in
    ("sesame") echo "openrdf-sesame/repositories/$6/statements" ;;
    ("owlim") echo "openrdf-sesame/repositories/$6/statements" ;;
    ("fuseki") echo "$6/update" ;;
    (*) echo "$7 is an unknown RDF store. Configure manually."
        exit 1;;
  esac)

SPARQL_SERVICE_PATH=$(
  case "$7" in
    ("sesame") echo "openrdf-sesame/repositories/$6/rdf-graphs/service" ;;
    ("owlim") echo "openrdf-sesame/repositories/$6/rdf-graphs/service" ;;
    ("fuseki") echo "$6/data" ;;
    (*) echo "$7 is an unknown RDF store. Configure manually."
        exit 1;;
  esac)

sed -e "s@%SPARQL_QUERY_PATH%@$SPARQL_QUERY_PATH@g" -e "s@%SPARQL_UPDATE_PATH%@$SPARQL_UPDATE_PATH@g" -e "s@%SPARQL_SERVICE_PATH%@$SPARQL_SERVICE_PATH@g" $DIR/config.template.env > $DIR/config.properties.env
echo "Configuration file generated at $DIR/config.properties.env"