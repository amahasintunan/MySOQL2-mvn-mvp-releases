@REM File. mysoql2.bat
@REM Date. 07/21/2024
@REM Description.
@REM       MySOQL - A SOQL query tool implemented in Java/REST/Swing.
@REM       JAVA_HOME resolution: env → PATH → mysoql.ini
@ECHO off
SETLOCAL EnableDelayedExpansion

cd /d "%~dp0"

REM ── JAVA_HOME resolution: env → PATH → ini ──────────────────────────────
SET JAVA_CMD=
SET INI_FILE=mysoql.ini

REM Step 1: %%JAVA_HOME%% from environment
IF NOT "%JAVA_HOME%" == "" (
   IF EXIST "%JAVA_HOME%\bin\java.exe" (
      SET "JAVA_CMD=%JAVA_HOME%\bin\java.exe"
   )
)

REM Step 2: java on PATH
IF "%JAVA_CMD%" == "" (
   WHERE java >nul 2>&1
   IF NOT ERRORLEVEL 1 SET "JAVA_CMD=java"
)

REM Step 3: JAVA_HOME from ini file
IF "%JAVA_CMD%" == "" (
   IF EXIST "%INI_FILE%" (
      FOR /F "tokens=1,2 delims==" %%A IN (%INI_FILE%) DO (
         IF "%%A" == "JAVA_HOME" (
            SET "JAVA_HOME_TMP=%%B"
            REM Strip surrounding quotes if present
            SET "JAVA_HOME=!JAVA_HOME_TMP:"=!"
         )
      )
      IF NOT "!JAVA_HOME!" == "" (
         IF EXIST "!JAVA_HOME!\bin\java.exe" (
            SET "JAVA_CMD=!JAVA_HOME!\bin\java.exe"
         )
      )
   )
)

IF "%JAVA_CMD%" == "" (
   ECHO ERROR: JAVA_HOME is not set.
   ECHO   Set JAVA_HOME in the environment, ensure java is on PATH, or edit %INI_FILE%
   EXIT /b 1
)

ECHO JAVA_CMD=%JAVA_CMD%
"%JAVA_CMD%" -version

SET ORIG_CP=%CLASSPATH%
SET CLASSPATH=.\;mysoql.jar
SET CLASSPATH=%CLASSPATH%;misc\gson-2.8.6.jar
SET CLASSPATH=%CLASSPATH%;misc\log4j-api-2.17.1.jar
SET CLASSPATH=%CLASSPATH%;misc\log4j-core-2.17.1.jar
SET CLASSPATH=%CLASSPATH%;misc\guava-20.0.jar
SET CLASSPATH=%CLASSPATH%;misc\language-detector-0.6.jar
SET CLASSPATH=%CLASSPATH%;misc\slf4j-api-1.7.36.jar
SET CLASSPATH=%CLASSPATH%;misc\tika-core-1.24.jar
SET CLASSPATH=%CLASSPATH%;misc\tika-parsers-1.24.jar
SET CLASSPATH=%CLASSPATH%;misc\tika-langdetect-1.24.jar
REM ==============================
REM Ora*i18n LCSD jars (Oracle proprietary — excluded from distribution).
REM Users who need Oracle LCSD can drop these jars into misc/:
FOR %%f IN ("misc\orai18n*.jar") DO SET CLASSPATH=%CLASSPATH%;%%f
FOR %%f IN ("misc\orai18n-mapping*.jar") DO SET CLASSPATH=%CLASSPATH%;%%f
FOR %%f IN ("misc\orai18n-lcsd*.jar") DO SET CLASSPATH=%CLASSPATH%;%%f
REM
REM Oracle JDBC driver (Oracle OTN — excluded from distribution).
REM Download from Oracle and place in misc/:
REM   https://www.oracle.com/database/technologies/appdev/jdbc-downloads.html
FOR %%f IN ("misc\ojdbc*.jar") DO SET CLASSPATH=%CLASSPATH%;%%f

:loop
"%JAVA_CMD%" -cp %CLASSPATH% -Xms2g -Xmx8g -Dlog4j.configurationFile=log4j2.xml -Dmysoql.config=mysoql.xml mysoql.MySOQL
set ERRLVL=%ERRORLEVEL%
if %ERRLVL% equ 127 (
    echo The specified JAVA path does not exist. Check the setting of JAVA_HOME in mysoql.ini.
    goto end
)
if %ERRLVL% equ 11 (
    echo User requests to relaunch the application.
    goto loop
)
:end
SET CLASSPATH=%ORIG_CP%
echo The application exits with code %ERRLVL%
exit /b %ERRLVL%
