@echo off
setlocal

echo ========================================================
echo   Student Profile Display System - Deploy to Tomcat 10.1
echo ========================================================
echo.

set WAR_FILE=target\StudentProfileProject.war

if not exist "%WAR_FILE%" (
    echo [ERROR] %WAR_FILE% does not exist!
    echo Please run build.bat first to build the WAR package.
    pause
    exit /b 1
)

set TOMCAT_DIR=""

REM 1. Check user's downloaded Tomcat 10.1.61 directory
if exist "C:\Users\rdivy\Downloads\apache-tomcat-10.1.61-windows-x64\apache-tomcat-10.1.61\webapps" (
    set TOMCAT_DIR="C:\Users\rdivy\Downloads\apache-tomcat-10.1.61-windows-x64\apache-tomcat-10.1.61"
    goto FOUND_TOMCAT
)

REM 2. Check environment variable CATALINA_HOME
if defined CATALINA_HOME (
    if exist "%CATALINA_HOME%\webapps" (
        set TOMCAT_DIR="%CATALINA_HOME%"
        goto FOUND_TOMCAT
    )
)

:PROMPT_USER
echo Tomcat 10.1 webapps folder not automatically found.
set /p TOMCAT_DIR="Enter path to your Tomcat 10.1 root directory: "

:FOUND_TOMCAT
echo Using Tomcat directory: %TOMCAT_DIR%
echo Copying %WAR_FILE% to %TOMCAT_DIR%\webapps\ ...
copy /Y "%WAR_FILE%" %TOMCAT_DIR%\webapps\

if %ERRORLEVEL% equ 0 (
    echo.
    echo ========================================================
    echo   DEPLOYMENT SUCCESSFUL!
    echo   Copied StudentProfileProject.war to %TOMCAT_DIR%\webapps\
    echo.
    echo   To run Tomcat:
    echo   1. Go to %TOMCAT_DIR%\bin
    echo   2. Run startup.bat
    echo   3. Open browser: http://localhost:8080/StudentProfileProject/
    echo ========================================================
) else (
    echo.
    echo [ERROR] Failed to copy WAR file. Check directory permissions.
)

echo.
pause
