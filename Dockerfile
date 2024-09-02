FROM maven:3.8.3-openjdk-17 as base

COPY pom.xml .
RUN mvn dependency:go-offline
COPY src ./src

RUN mvn clean package --file pom.xml

FROM openjdk:17-slim as run_time

COPY --from=base /target/my-app-*.jar /target/my-app-*.jar

CMD ["java", "-jar", "/target/my-app-*.jar"]
