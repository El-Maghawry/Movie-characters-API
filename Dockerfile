FROM gradle:jdk17 AS gradle
WORKDIR /app
COPY . .
# fix https://stackoverflow.com/questions/61301818/java-failed-to-exec-spawn-helper-error-since-moving-to-java-14-on-linux
ENV JAVA_TOOL_OPTIONS="-Djdk.lang.Process.launchMechanism=vfork"
RUN gradle bootJar --stacktrace

FROM openjdk:17 as runtime
WORKDIR /app
ENV PORT 8080
ENV SPRING_PROFILE production
ENV DATABASE_URL ""
ENV DDL_AUTO "create"
COPY --from=gradle /app/build/libs/*.jar /app/app.jar
RUN chown -R 1000:1000 /app
USER 1000:1000
ENTRYPOINT ["java","-jar", \
    "-Dserver.port=${PORT}", \
    "-Dspring.profiles.active=${SPRING_PROFILE}", \
    "-Dspring.datasource.url=jdbc:${DATABASE_URL}", \
    "-Dspring.jpa.hibernate.ddl-auto=${DDL_AUTO}", \
    "app.jar"]
