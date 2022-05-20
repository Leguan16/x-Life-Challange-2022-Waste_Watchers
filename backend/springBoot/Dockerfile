FROM openjdk:17
ADD target/backend-docker.jar backend-docker.jar
ENTRYPOINT ["java", "-jar", "backend-docker.jar"]
EXPOSE 15431
