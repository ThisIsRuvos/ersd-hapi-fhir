#!/usr/bin/env bash

set -e

HAPI_PROPERTIES_PATH=${HAPI_PROPERTIES_PATH:-'/usr/local/tomcat/webapps/hapi-fhir-jpaserver/WEB-INF/classes/hapi.properties'}
SERVER_ADDRESS=${SERVER_ADDRESS:-'http://kds-hapi-fhir:8080/hapi-fhir-jpaserver/fhir'}
SERVER_NAME=${SERVER_NAME:-'HAPI_DSTU3'}
DATASOURCE_DRIVER=${DATASOURCE_DRIVER:-'com.mysql.cj.jdbc.Driver'}
DATASOURCE_URL=${DATASOURCE_URL:-'jdbc:mysql://db:3306/hapi_dstu3?useSSL=false&serverTimezone=UTC'}
HIBERNATE_DIALECT=${HIBERNATE_DIALECT:-'org.hibernate.dialect.MySQL5Dialect'}
HIBERNATE_INDEX_BASE=${HIBERNATE_INDEX_BASE:-'/data/hapi_dstu3/lucenefiles'}
RESTHOOK_ENABLED=${RESTHOOK_ENABLED:-'true'}
EMAIL_ENABLED=${EMAIL_ENABLED:-'true'}
EMAIL_FROM=${EMAIL_FROM:-'sandboxsupport@aimsplatform.com'}
EMAIL_HOST=${EMAIL_HOST:-'aws-smtp-relay'}
EMAIL_PORT=${EMAIL_PORT:-'10025'}

sed -i '/^server_address/c\server_address='$SERVER_ADDRESS $HAPI_PROPERTIES_PATH
sed -i '/^server.name/c\server.name='$SERVER_NAME $HAPI_PROPERTIES_PATH
sed -i '/^datasource.driver/c\datasource.driver='$DATASOURCE_DRIVER $HAPI_PROPERTIES_PATH
sed -i '/^datasource.url/c\datasource.url='$DATASOURCE_URL $HAPI_PROPERTIES_PATH
sed -i '/^datasource.username/c\datasource.username='$DATASOURCE_USERNAME $HAPI_PROPERTIES_PATH
sed -i '/^datasource.password/c\datasource.password='$DATASOURCE_PASSWORD $HAPI_PROPERTIES_PATH
sed -i '/^hibernate.dialect/c\hibernate.dialect='$HIBERNATE_DIALECT $HAPI_PROPERTIES_PATH
sed -i '/^hibernate.search.default.indexBase/c\hibernate.search.default.indexBase='$HIBERNATE_INDEX_BASE $HAPI_PROPERTIES_PATH
sed -i '/^subscription.resthook/c\subscription.resthook.enabled='$RESTHOOK_ENABLED $HAPI_PROPERTIES_PATH
sed -i '/^subscription.email.enabled/c\subscription.email.enabled='$EMAIL_ENABLED $HAPI_PROPERTIES_PATH
sed -i '/^email.enabled/c\email.enabled='$EMAIL_ENABLED $HAPI_PROPERTIES_PATH
sed -i '/^email.from/c\email.from='$EMAIL_FROM $HAPI_PROPERTIES_PATH
sed -i '/^email.host/c\email.host='$EMAIL_HOST $HAPI_PROPERTIES_PATH
sed -i '/^email.port/c\email.port='$EMAIL_PORT $HAPI_PROPERTIES_PATH

# run tomcat
./catalina.sh run