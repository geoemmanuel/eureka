@echo off
echo ========================================
echo Starting Netflix Eureka Load Balancer
echo ========================================
echo.

color 0A

echo [INFO] Starting Eureka Server...
start "Eureka Server" cmd /k "cd eureka-server && echo Starting Eureka Server on port 8761... && mvn spring-boot:run"

echo [INFO] Waiting 30 seconds for Eureka Server to start...
timeout /t 30 /nobreak > nul

echo [INFO] Starting User Service Instance 1 (Port 8081)...
start "User Service - Port 8081" cmd /k "cd user-service && echo Starting User Service on port 8081... && mvn spring-boot:run"

echo [INFO] Starting User Service Instance 2 (Port 8082)...
start "User Service - Port 8082" cmd /k "cd user-service && echo Starting User Service on port 8082... && mvn spring-boot:run -Dspring-boot.run.arguments=--server.port=8082"

echo [INFO] Starting User Service Instance 3 (Port 8083)...
start "User Service - Port 8083" cmd /k "cd user-service && echo Starting User Service on port 8083... && mvn spring-boot:run -Dspring-boot.run.arguments=--server.port=8083"

echo [INFO] Waiting 45 seconds for User Services to register with Eureka...
timeout /t 45 /nobreak > nul

echo [INFO] Starting Load Balancer Client (Port 8080)...
start "Load Balancer Client" cmd /k "cd load-balancer-client && echo Starting Load Balancer Client on port 8080... && mvn spring-boot:run"

echo.
echo ========================================
echo All services are starting up!
echo ========================================
echo.
echo Please wait for all services to fully start before testing.
echo.
echo Service URLs:
echo - Eureka Dashboard: http://localhost:8761
echo - User Service 1:   http://localhost:8081/users
echo - User Service 2:   http://localhost:8082/users
echo - User Service 3:   http://localhost:8083/users
echo - Load Balancer:    http://localhost:8080/api/users
echo - Load Balance Test: http://localhost:8080/api/test-load-balancing
echo.
echo Press any key to open the Eureka Dashboard in your browser...
pause > nul

REM Open Eureka Dashboard in default browser
start http://localhost:8761

echo.
echo ========================================
echo Services Status Check
echo ========================================
echo.
echo Checking if services are responding...
timeout /t 10 /nobreak > nul

REM Simple health check using curl (if available)
where curl >nul 2>&1
if %errorlevel% == 0 (
    echo [HEALTH CHECK] Testing Eureka Server...
    curl -s http://localhost:8761 >nul && echo [OK] Eureka Server is responding || echo [FAIL] Eureka Server not responding

    echo [HEALTH CHECK] Testing Load Balancer Client...
    curl -s http://localhost:8080/actuator/health >nul && echo [OK] Load Balancer Client is responding || echo [FAIL] Load Balancer Client not responding
) else (
    echo [INFO] curl not found. Manual health check required.
    echo [INFO] Please check the service URLs manually in your browser.
)

echo.
echo ========================================
echo Setup Complete!
echo ========================================
echo.
echo All services should now be running. You can:
echo 1. Check the Eureka Dashboard to see registered services
echo 2. Test individual user services directly
echo 3. Test load balancing through the client
echo.
echo To stop all services, close all the command windows or press Ctrl+C in each.
echo.
echo Press any key to exit this setup script...
pause > nul