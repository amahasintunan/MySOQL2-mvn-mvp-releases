#!/bin/bash
# 
# File. mysoql2.sh
# Date. 12/13/2020
# Description.
#       MySOQL - A SOQL query tool implemented in Java/REST/Swing.
#

cd "`dirname $0`"

# ── JAVA_HOME resolution: env → PATH → ini ────────────────────────────────
JAVA_CMD=""
INI_FILE="mysoql.ini"

# Step 1: $JAVA_HOME from environment
if [ -n "${JAVA_HOME:-}" ] && [ -d "$JAVA_HOME" ] && [ -x "$JAVA_HOME/bin/java" ]; then
  JAVA_CMD="$JAVA_HOME/bin/java"
fi

# Step 2: java on PATH
if [ -z "$JAVA_CMD" ] && command -v java >/dev/null 2>&1; then
  JAVA_CMD="java"
fi

# Step 3: JAVA_HOME from ini file
if [ -z "$JAVA_CMD" ]; then
  if [ -f "$INI_FILE" ]; then
    while IFS='=' read -r f1 f2; do
      if [ "$f1" == "JAVA_HOME" ]; then
        JAVA_HOME=$f2
        break
      fi
    done <"$INI_FILE"
    if [ -n "$JAVA_HOME" ] && [ -d "$JAVA_HOME" ] && [ -x "$JAVA_HOME/bin/java" ]; then
      JAVA_CMD="$JAVA_HOME/bin/java"
    fi
  fi
fi

if [ -z "$JAVA_CMD" ]; then
  echo "ERROR: JAVA_HOME is not set."
  echo "  Set JAVA_HOME in the environment, ensure java is on PATH, or edit $INI_FILE"
  exit 1
fi

[ -n "${JAVA_HOME:-}" ] && PATH=$JAVA_HOME/bin:$PATH
ORIG_CP=$CLASSPATH
CLASSPATH=./:mysoql.jar
CLASSPATH=$CLASSPATH:misc/gson-2.8.6.jar
CLASSPATH=$CLASSPATH:misc/log4j-api-2.17.1.jar
CLASSPATH=$CLASSPATH:misc/log4j-core-2.17.1.jar
CLASSPATH=$CLASSPATH:misc/log4j-slf4j-impl-2.17.1.jar
CLASSPATH=$CLASSPATH:misc/guava-20.0.jar
CLASSPATH=$CLASSPATH:misc/language-detector-0.6.jar
CLASSPATH=$CLASSPATH:misc/slf4j-api-1.7.36.jar
CLASSPATH=$CLASSPATH:misc/tika-core-1.24.jar
CLASSPATH=$CLASSPATH:misc/tika-parsers-1.24.jar
CLASSPATH=$CLASSPATH:misc/tika-langdetect-1.24.jar

# Ora*i18n LCSD jars (Oracle proprietary — excluded from distribution).
# Users who need Oracle LCSD can drop these jars into misc/:
[ -f "misc/orai18n"*".jar" ]        && CLASSPATH=$CLASSPATH:$(echo misc/orai18n*.jar | head -1)
[ -f "misc/orai18n-mapping"*".jar" ]   && CLASSPATH=$CLASSPATH:$(echo misc/orai18n-mapping*.jar | head -1)
[ -f "misc/orai18n-lcsd"*".jar" ]      && CLASSPATH=$CLASSPATH:$(echo misc/orai18n-lcsd*.jar | head -1)

# Oracle JDBC driver (Oracle OTN — excluded from distribution).
# Users who need Oracle JDBC must download it from Oracle and place in misc/:
#   https://www.oracle.com/database/technologies/appdev/jdbc-downloads.html
[ -f "misc/ojdbc"*".jar" ]          && CLASSPATH=$CLASSPATH:$(echo misc/ojdbc*.jar | head -1)

printf  "%s\n`$JAVA_CMD -fullversion`"
while true; do
  $JAVA_CMD -cp $CLASSPATH -Xms2g -Xmx8g -Dlog4j.configurationFile=log4j2.xml -Dmysoql.config=mysoql.xml mysoql.MySOQL
  rc=$?
  if [ $rc -eq 127 ]; then
    # exit code 127 - command not found
    echo "The specified JAVA path does not exist. Check the setting of JAVA_HOME in the script."
    break;
  elif [ $rc -eq 11 ]; then
    # Restart the application user updates certificate
    echo "User requests to relaunch the application."
  else
    break;
  fi
done
CLASSPATH=$ORIG_CP
echo "The application exits with code" $rc
exit $rc
