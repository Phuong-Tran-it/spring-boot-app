FROM openjdk:17-slim

ARG JAR_NAME

WORKDIR /app
COPY target/${JAR_NAME} app.jar
EXPOSE 3001
ENTRYPOINT ["java","-jar","app.jar", "--server.port=3001"]
