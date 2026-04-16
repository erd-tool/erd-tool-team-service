FROM gradle:8.10.2-jdk21 AS build
WORKDIR /workspace
ARG GITHUB_ACTOR
ARG GITHUB_TOKEN
ENV GITHUB_ACTOR=$GITHUB_ACTOR
ENV GITHUB_TOKEN=$GITHUB_TOKEN
COPY . .
RUN gradle bootJar -x test --no-daemon

FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
RUN apk add --no-cache wget
COPY --from=build /workspace/build/libs/*.jar app.jar
EXPOSE 8082
ENTRYPOINT ["java", "-jar", "app.jar"]
