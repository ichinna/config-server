FROM maven:3.6.3-openjdk-11 AS build

RUN rm -rf /usr/src/app/src

COPY src /usr/src/app/src

COPY pom.xml /usr/src/app

RUN mvn -f /usr/src/app/pom.xml clean package -DskipTests

RUN ls /usr/src/app/target

FROM openjdk:11-jdk AS configdeploy

RUN mkdir -p /root/.m2

COPY --from=build /usr/src/app/target/config*.jar /usr/local/lib/config.jar
COPY --from=build /root/.m2 /root/.m2

CMD ["catalina.sh", "run"]
ENTRYPOINT exec java $JAVA_OPTS -jar  "/usr/local/lib/config.jar"

