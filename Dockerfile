# Stage 1: Build the app with Maven + Java 21
FROM maven:3.8.6-amazoncorretto-21 AS build

WORKDIR /app

# Copy pom.xml first to download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source code and build the jar
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Runtime image (lighter)
FROM amazoncorretto:21-alpine
WORKDIR /app

# Copy the built jar from the build stage
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
