@echo off
setlocal

echo ========================================================
echo   Student Profile Display System - Maven Build Script
echo ========================================================
echo.

REM Determine Maven executable path
where mvn >nul 2>&1
if %ERRORLEVEL% equ 0 (
    set MVN_CMD=mvn
) else if exist "C:\Users\rdivy\apache-maven-3.9.6\bin\mvn.cmd" (
    set MVN_CMD="C:\Users\rdivy\apache-maven-3.9.6\bin\mvn.cmd"
) else (
    echo [ERROR] Maven not found in PATH or at C:\Users\rdivy\apache-maven-3.9.6\bin\mvn.cmd
    echo Please install Apache Maven and add its bin directory to PATH.
    pause
    exit /b 1
)

echo Using Maven command: %MVN_CMD%
echo.
echo Running 'clean package' to compile Java 21 sources and package WAR...
call %MVN_CMD% clean package

if %ERRORLEVEL% equ 0 (
    echo.
    echo ========================================================
    echo   BUILD SUCCESSFUL!
    echo   WAR package created at: target\StudentProfileProject.war
    echo ========================================================
) else (
    echo.
    echo ========================================================
    echo   [ERROR] Maven build failed. Check error logs above.
    echo ========================================================
)

echo.
pause
