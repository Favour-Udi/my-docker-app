# Stage 1: Build the app with Maven + Java21
FROM maven:3.9-eclipse-temurin-21 AS build

WORKDIR /app

# Copy pom.xml for dependency resolution caching
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy the source and build the jar
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Runtime image (lighter) using Alpine + Java21
FROM eclipse-temurin:21-jre-alpine

WORKDIR /app
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
