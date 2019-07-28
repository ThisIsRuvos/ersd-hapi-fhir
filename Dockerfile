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
WORKDIR /tmp/hapi-fhir/hapi-fhir-jpaserver-subscription
RUN git checkout 3.8-subscription-payload
RUN mvn install -DskipTests
WORKDIR /tmp/hapi-fhir/hapi-fhir-jpaserver-base
RUN mvn install -DskipTests

WORKDIR /tmp
RUN git clone https://github.com/hapifhir/hapi-fhir-jpaserver-starter

WORKDIR /tmp/hapi-fhir-jpaserver-starter
RUN mvn install:install-file -Dfile=/tmp/hapi-fhir/hapi-fhir-jpaserver-subscription/target/hapi-fhir-jpaserver-subscription-3.8.0.jar -DskipTests
RUN mvn install:install-file -Dfile=/tmp/hapi-fhir/hapi-fhir-jpaserver-base/target/hapi-fhir-jpaserver-base-3.8.0.jar -DskipTests
RUN mvn install -DskipTests

FROM tomcat:9-jre8

RUN mkdir -p /data/hapi_dstu3/lucenefiles && chmod 775 /data/hapi_dstu3/lucenefiles
COPY --from=build-hapi /tmp/hapi-fhir-jpaserver-starter/target/*.war /usr/local/tomcat/webapps/
COPY tomcat-users.xml /usr/local/tomcat/conf/
COPY run.sh ./
RUN sed -i '/allow=/c\allow="\\d+\\.\\d+\\.\\d+\\.\\d+" />' /usr/local/tomcat/webapps/manager/META-INF/context.xml

EXPOSE 8080

CMD ["run.sh"]