# Stage 1: Build the app
FROM amazoncorretto:21 AS build

# Install Maven and other dependencies
RUN yum update -y && \
    yum install -y maven wget tar gzip

WORKDIR /app

# Copy pom.xml first to download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source code and build jar
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Runtime image (smaller)
FROM amazoncorretto:21-alpine
WORKDIR /app

# Copy the built jar from the build stage
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
