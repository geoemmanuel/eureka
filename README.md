# Netflix Eureka Load Balancer 

This project demonstrates a microservices architecture with service discovery and client-side load balancing using Spring Cloud and Netflix Eureka.

## Project Structure

The project consists of three modules:

1. **Eureka Server** - Service registry where all microservices register
2. **User Service** - A simple service that registers with the Eureka server
3. **Load Balancer Client** - Uses Spring Cloud LoadBalancer for client-side load balancing

## Prerequisites

- Java 11 or higher
- Maven

## Running the Application

### 1. Start the Eureka Server

```bash
cd eureka-server
mvn spring-boot:run
```

Access the Eureka dashboard at: http://localhost:8761

### 2. Start Multiple User Service Instances

There are several ways to start multiple instances of the user-service for testing load balancing:

#### Method 1: Using Command-Line Arguments

Start the first instance on port 8081 (default):
```bash
cd user-service
mvn spring-boot:run
```

Start additional instances on different ports using command-line arguments:
```bash
cd user-service
mvn spring-boot:run -Dspring-boot.run.arguments=--server.port=8082
```

```bash
cd user-service
mvn spring-boot:run -Dspring-boot.run.arguments=--server.port=8083
```

#### Method 2: Using Environment Variables

The application is configured to use the `PORT` environment variable. You can start multiple instances by setting different values for this variable:

Windows (PowerShell):
```powershell
cd user-service
$env:PORT=8082; mvn spring-boot:run
```

Windows (Command Prompt):
```cmd
cd user-service
set PORT=8082
mvn spring-boot:run
```

Linux/macOS:
```bash
cd user-service
PORT=8082 mvn spring-boot:run
```

#### Method 3: Using Different Configuration Files

You can create different configuration files for different instances:

1. Create `application-instance1.yml`, `application-instance2.yml`, etc. in the `user-service/src/main/resources` directory with different port configurations:

```yaml
# application-instance1.yml
server:
  port: 8082
```

```yaml
# application-instance2.yml
server:
  port: 8083
```

2. Start each instance with a specific profile:

```bash
cd user-service
mvn spring-boot:run -Dspring.profiles.active=instance1
```

```bash
cd user-service
mvn spring-boot:run -Dspring.profiles.active=instance2
```

#### Method 4: Using Batch/Shell Scripts

For convenience, you can create scripts to start multiple instances at once:

Windows (batch file - `start-instances.bat`):
```batch
@echo off
start cmd /k "cd user-service && mvn spring-boot:run"
start cmd /k "cd user-service && mvn spring-boot:run -Dspring-boot.run.arguments=--server.port=8082"
start cmd /k "cd user-service && mvn spring-boot:run -Dspring-boot.run.arguments=--server.port=8083"
```

Linux/macOS (shell script - `start-instances.sh`):
```bash
#!/bin/bash
gnome-terminal -- bash -c "cd user-service && mvn spring-boot:run"
gnome-terminal -- bash -c "cd user-service && mvn spring-boot:run -Dspring-boot.run.arguments=--server.port=8082"
gnome-terminal -- bash -c "cd user-service && mvn spring-boot:run -Dspring-boot.run.arguments=--server.port=8083"
```

Make the script executable (Linux/macOS):
```bash
chmod +x start-instances.sh
```

### 3. Start the Load Balancer Client

```bash
cd load-balancer-client
mvn spring-boot:run
```

## Testing the Load Balancing

1. Access the user service directly:
   - http://localhost:8081/users
   - http://localhost:8082/users
   - http://localhost:8083/users

2. Access the user service through the load balancer:
   - http://localhost:8080/api/users

3. Test load balancing with multiple requests:
   - http://localhost:8080/api/test-load-balancing

   This will make 10 requests to the user service and show which instance handled each request.

4. Check the health of the user service:
   - http://localhost:8080/actuator/health

## Features Implemented

1. **Service Discovery** - Using Netflix Eureka
2. **Client-Side Load Balancing** - Using Spring Cloud LoadBalancer
3. **Custom Load Balancing Rules** - Configured in LoadBalancerConfig
4. **Health Monitoring** - Custom health indicator for the user service

## Load Balancing Strategies

The application demonstrates the use of the RoundRobinLoadBalancer strategy, but you can also use:
- RandomLoadBalancer
- WeightedResponseTimeLoadBalancer (via custom implementation)

## Configuration

Key configuration files:
- `eureka-server/src/main/resources/application.yml` - Eureka server configuration
- `user-service/src/main/resources/application.yml` - User service configuration
- `load-balancer-client/src/main/resources/application.yml` - Load balancer client configuration

## Benefits

- **Service Discovery**: Automatic registration and discovery of services
- **Client-Side Load Balancing**: Reduces latency and server load
- **High Availability**: Automatic failover when instances go down
- **Scalability**: Easy to add/remove service instances
- **Health Monitoring**: Built-in health checks and monitoring
