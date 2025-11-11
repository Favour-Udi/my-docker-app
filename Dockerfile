# Stage 1: Build the app with Maven 3.9.11 + Java 21
FROM maven:3.9.11‑amazoncorretto‑21‑debian AS build

WORKDIR /app

# Copy pom and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source and build the jar
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Runtime image (lighter)
FROM amazoncorretto:21‑alpine
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java","-jar","app.jar"]
