# Usamos Java 17
FROM eclipse-temurin:17-jdk-jammy AS build

WORKDIR /app

# Copiamos archivos mvnw y pom.xml
COPY pom.xml mvnw ./

# Damos permisos de ejecución al mvnw
RUN chmod +x mvnw

# Copiamos .mvn
COPY .mvn .mvn

# Instalamos dependencias offline
RUN ./mvnw dependency:go-offline

# Copiamos código fuente
COPY src ./src

# Build del proyecto (skip tests)
RUN ./mvnw package -DskipTests

# --- ETAPA FINAL ---
FROM eclipse-temurin:17-jdk-jammy

WORKDIR /app

# Copiamos jar desde build
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8081

ENTRYPOINT ["java", "-jar", "app.jar"]
