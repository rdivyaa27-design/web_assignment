@echo off
setlocal

echo ========================================================
echo   Student Profile Display System - Database Setup
echo ========================================================
echo.

set MYSQL_BIN=""

REM 1. Check if mysql is directly available in PATH
where mysql >nul 2>&1
if %ERRORLEVEL% equ 0 (
    set MYSQL_BIN=mysql
    goto FOUND_MYSQL
)

REM 2. Check standard MySQL Server 8.0 installation path
if exist "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" (
    set MYSQL_BIN="C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe"
    goto FOUND_MYSQL
)

REM 3. Check XAMPP MySQL installation path
if exist "C:\xampp\mysql\bin\mysql.exe" (
    set MYSQL_BIN="C:\xampp\mysql\bin\mysql.exe"
    goto FOUND_MYSQL
)

REM Fallback: default to mysql command
set MYSQL_BIN=mysql

:FOUND_MYSQL
echo Detected MySQL client: %MYSQL_BIN%
echo Target SQL script: database.sql
echo.
echo Please enter your MySQL 'root' password:
echo (If you do not have a password set, just press ENTER)
echo.
set /p DB_PASS="Enter Password: "

echo.
if "%DB_PASS%"=="" (
    echo Executing database.sql with root (empty password)...
    %MYSQL_BIN% -u root < database.sql
) else (
    echo Executing database.sql with root and provided password...
    %MYSQL_BIN% -u root -p%DB_PASS% < database.sql
)

if %ERRORLEVEL% equ 0 (
    echo.
    echo ========================================================
    echo   DATABASE SETUP SUCCESSFUL!
    echo   Created database 'student_db' and populated 'students' table.
    echo ========================================================
) else (
    echo.
    echo ========================================================
    echo   [ERROR] Failed to run database.sql.
    echo   Please check that your MySQL password is correct.
    echo ========================================================
)

echo.
pause
