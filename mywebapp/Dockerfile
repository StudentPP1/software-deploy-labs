FROM gradle:9-alpine AS builder

WORKDIR /mywebapp
COPY build.gradle settings.gradle ./
COPY src ./src
RUN gradle bootJar -x test

FROM eclipse-temurin:25-jre-alpine

RUN apk add --no-cache curl

WORKDIR /mywebapp
COPY --from=builder /mywebapp/build/libs/*.jar app.jar

ENTRYPOINT ["java", "-jar", "app.jar"]