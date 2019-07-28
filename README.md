# ersd-hapi-fhir
> Dockerized HAPI FHIR Server for ERSD

Built from [hapi-fhir-jpaserver-starter](https://github.com/hapifhir/hapi-fhir-jpaserver-starter) and [hapi-fhir](https://github.com/lantanagroup/hapi-fhir)

## Build
Generic
```bash
docker build -t ersd-hapi-fhir .
```
Tagged to Ruvos Registry
```bash
docker build -t registry.ruvos.com/ersd/ersd-hapi-fhir .
```

## Push a Build to Ruvos Registry
```bash
# login if necessary
docker login registry.ruvos.com
# or with credentials inline
docker login -u <USERNAME> -p <PASSWORD> registry.ruvos.com

docker push registry.ruvos.com/ersd/ersd-hapi-fhir
```

## Pull Latest Build from Ruvos Registry
```bash
# login if necessary
docker login registry.ruvos.com
# or with credentials inline
docker login -u <USERNAME> -p <PASSWORD> registry.ruvos.com

docker pull registry.ruvos.com/ersd/ersd-hapi-fhir
```


## Run
Generic
```bash
docker run -p 8080:8080 -t ersd-hapi-fhir
```
Using Ruvos Registry
```bash
docker run -p 8080:8080 -t registry.ruvos.com/ersd/ersd-hapi-fhir
```
With Environment Variables
```bash
docker run -p 8080:8080 -e <VARIABLE_NAME>=<VALUE> -t registry.ruvos.com/ersd/ersd-hapi-fhir
```

Notes
- Make sure to route port 8080


## Environment Variables
|Name|Description|Default|
|---|---|---|
|SERVER_ADDRESS|URI for this service including path to fhir (e.g. `hapi-fhir-jpaserver/fhir`)|http://ersd-hapi-fhir:8080/hapi-fhir-jpaserver/fhir|
|SERVER_NAME|A name for the server|HAPI_DSTU3|
|DATASOURCE_DRIVER|Full class name of the driver to use for connecting to a datasource|com.mysql.cj.jdbc.Driver|
|DATASOURCE_URL|URL for the datasource. Note that for something like MySQL this includes the database name.|jdbc:mysql://db:3306/hapi_dstu3|
|DATASOURCE_USERNAME|Username for authenticating against the datasource||
|DATASOURCE_PASSWORD|Password for authenticating against the datasource||
|HIBERNATE_DIALECT|Library that lets stuff talk to the datasource. Should match datasource configuration. e.g. Use a MySQL dialect for a MySQL datasource.|org.hibernate.dialect.MySQL5Dialect|
|HIBERNATE_INDEX_BASE|A path for Hibernate-related search indexing.|/data/hapi_dstu3/lucenefiles|
|RESTHOOK_ENABLED|Flag indicating if resthook subscriptions should be enabled|true|
|EMAIL_ENABLED|Flag indicating if emails and email subscriptions should be enabled|true|
|EMAIL_FROM|From address to use when sending emails|sandboxsupport@aimsplatform.com|
|EMAIL_HOST|Hostname of email server|aws-smtp-relay|
|EMAIL_PORT|SMTP port on email server|10025|
