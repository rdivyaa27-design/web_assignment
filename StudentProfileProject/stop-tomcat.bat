@echo off
setlocal

echo Stopping Apache Tomcat 10.1...

if not defined JAVA_HOME (
    set "JAVA_HOME=C:\Program Files\Java\jdk-21"
)

set "CATALINA_HOME=C:\Users\rdivy\Downloads\apache-tomcat-10.1.61-windows-x64\apache-tomcat-10.1.61"

cd /d "%CATALINA_HOME%\bin"
call shutdown.bat

echo Tomcat stopped.
pause
