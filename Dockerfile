FROM maven:3.8.6-openjdk-11-slim as builder

COPY src /usr/src/app/src
COPY pom.xml /usr/src/app

# Java requires key in pk8; pk8 is binary and cannot be checked into some source control system such as gitlab.
COPY db-certs/client-key.pem ./client-key.pem
RUN openssl pkcs8 -topk8 -inform PEM -outform DER -in ./client-key.pem -out ./client-key.pk8 -nocrypt

RUN mvn -f /usr/src/app/pom.xml -Dmaven.test.skip=true clean package

FROM openjdk:11-jre-slim-buster 
#FROM adoptopenjdk:11-jre-hotspot
ARG ARTIFACT=sb-postgres-ex
ENV server_port=8080
ENV spring_jpa_show-sql=true
ENV spring_datasource_url=jdbc:postgresql://10.9.98.2:5432/pgsql-d-use4-lcef-rules-repo?sslmode=verify-ca&sslrootcert=./server-ca.pem&sslcert=./client-cert.pem&sslkey=./client-key.pk8
ENV spring_datasource_username=lcef_application
ENV spring_datasource_password=owuhf8#x8LL

COPY --from=builder /usr/src/app/target/sb-postgres-ex-1.0-SNAPSHOT.jar /sb-postgres-ex-1.0-SNAPSHOT.jar

COPY db-certs/client-cert.pem ./client-cert.pem
# copy key converted in builder to here
COPY --from=builder ./client-key.pk8 ./client-key.pk8
#COPY db-certs/client-key.pk8 /client-key.pk8
COPY db-certs/server-ca.pem /server-ca.pem

ENTRYPOINT java -jar sb-postgres-ex-1.0-SNAPSHOT.jar
EXPOSE 8080
