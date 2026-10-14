@echo off
setlocal

echo ========================================================
echo   Student Profile Display System - Start Tomcat 10.1
echo ========================================================
echo.

if not defined JAVA_HOME (
    set "JAVA_HOME=C:\Program Files\Java\jdk-21"
)

set "CATALINA_HOME=C:\Users\rdivy\Downloads\apache-tomcat-10.1.61-windows-x64\apache-tomcat-10.1.61"

if not exist "%CATALINA_HOME%\bin\startup.bat" (
    echo [ERROR] Tomcat 10.1 not found at %CATALINA_HOME%
    pause
    exit /b 1
)

echo Using JAVA_HOME: %JAVA_HOME%
echo Using CATALINA_HOME: %CATALINA_HOME%
echo.
echo Starting Tomcat 10.1...
echo A new Tomcat command window will appear. Keep it open while using the app!
echo.

cd /d "%CATALINA_HOME%\bin"
call startup.bat

echo.
echo ========================================================
echo Tomcat is starting!
echo Once started, open your browser to:
echo http://localhost:8080/StudentProfileProject/
echo ========================================================
echo.
pause
