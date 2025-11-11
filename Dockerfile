# -------------------------------
# Stage 1: Build the app
# -------------------------------
FROM maven:3.9.11-openjdk-21 AS build

WORKDIR /app

# Copy pom.xml first to download dependencies (caches faster)
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source code and build the jar
COPY src ./src
RUN mvn clean package -DskipTests

# -------------------------------
# Stage 2: Runtime image (lighter)
# -------------------------------
FROM openjdk:21-alpine

WORKDIR /app

# Copy the built jar from the build stage
COPY --from=build /app/target/*.jar app.jar

# Expose default port
EXPOSE 8080

# Run the app
ENTRYPOINT ["java", "-jar", "app.jar"]
