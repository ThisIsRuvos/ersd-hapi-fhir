FROM ubuntu as build-hapi
ENV PATH="/tmp/apache-maven-3.6.0/bin:${PATH}"

WORKDIR /tmp
RUN apt-get update && \
	apt-get install git -y && \
	apt-get install sed -y && \
	apt-get install wget -y && \
    apt-get install openjdk-8-jdk -y

RUN wget https://www-eu.apache.org/dist/maven/maven-3/3.6.0/binaries/apache-maven-3.6.0-bin.tar.gz
RUN tar xzf apache-maven-3.6.0-bin.tar.gz
RUN export PATH=/tmp/apache-maven-3.6.0/bin:${PATH}

# Fetch and build forked and fixed jpaserver-base
RUN git clone https://github.com/lantanagroup/hapi-fhir.git
WORKDIR /tmp/hapi-fhir/hapi-fhir-jpaserver-base
RUN git checkout 3.8-subscription-payload
RUN mvn clean install package -DskipTests

WORKDIR /tmp
RUN git clone https://github.com/hapifhir/hapi-fhir-jpaserver-starter

WORKDIR /tmp/hapi-fhir-jpaserver-starter/src/main/resources
RUN sed -i '/server_address/c\server_address=http://kds-hapi-fhir:8080/hapi-fhir-jpaserver/fhir' hapi.properties && \
	# sed -i '/datasource.driver/c\datasource.driver=com.mysql.cj.jdbc.Driver' hapi.properties && \
	# sed -i '/datasource.url/c\datasource.url=jdbc:mysql://db:3306/hapi_dstu3?useSSL=false&serverTimezone=UTC' hapi.properties && \
	sed -i '/datasource.username/c\datasource.username=hapi_user' hapi.properties && \
	sed -i '/datasource.password/c\datasource.password=S3cretP8ss' hapi.properties && \
	sed -i '/server.name/c\server.name=HAPI DSTU3' hapi.properties && \
	# sed -i '/hibernate.dialect/c\hibernate.dialect=org.hibernate.dialect.MySQL5Dialect' hapi.properties && \
	sed -i '/hibernate.search.default.indexBase/c\hibernate.search.default.indexBase=/data/hapi_dstu3/lucenefiles' hapi.properties && \
	sed -i '/subscription.resthook/c\subscription.resthook.enabled=true' hapi.properties && \
	sed -i '/subscription.email.enabled/c\subscription.email.enabled=true' hapi.properties && \
	sed -i '/email.enabled/c\email.enabled=true' hapi.properties && \
	sed -i '/email.from/c\email.from=sandboxsupport@aimsplatform.com' hapi.properties && \
	sed -i '/email.host/c\email.host=aws-smtp-relay' hapi.properties && \
	sed -i '/email.port/c\email.port=10025' hapi.properties

WORKDIR /tmp/hapi-fhir-jpaserver-starter
RUN mvn clean install -DskipTests
RUN mvn install:install-file -Dfile=/tmp/hapi-fhir/hapi-fhir-jpaserver-base/target/hapi-fhir-jpaserver-base-3.8.0.jar -DskipTests
RUN mvn package

FROM tomcat:9-jre8

RUN mkdir -p /data/hapi_dstu3/lucenefiles && chmod 775 /data/hapi_dstu3/lucenefiles
COPY --from=build-hapi /tmp/hapi-fhir-jpaserver-starter/target/*.war /usr/local/tomcat/webapps/
COPY tomcat-users.xml /usr/local/tomcat/conf/
RUN sed -i '/allow=/c\allow="\\d+\\.\\d+\\.\\d+\\.\\d+" />' /usr/local/tomcat/webapps/manager/META-INF/context.xml

EXPOSE 8080

CMD ["catalina.sh", "run"]