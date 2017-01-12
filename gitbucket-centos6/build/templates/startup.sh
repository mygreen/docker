#!/bin/sh
#
# GitBucket startup script
#

GITBUCKET_LIB="/usr/lib/gitbucket"
GITBUCKET_WAR="$GITBUCKET_LIB/gitbucket.war"
GITBUCKET_CONFIG="$GITBUCKET_LIB//gitbucket.conf"

# Check for missing binaries (stale symlinks should not happen)
test -r "$GITBUCKET_WAR" || { echo "$GITBUCKET_WAR not installed";
	if [ "$1" = "stop" ]; then exit 0;
	else exit 5; fi; }

# Check for existence of needed config file and read it
test -e "$GITBUCKET_CONFIG" || { echo "$GITBUCKET_CONFIG not existing";
	if [ "$1" = "stop" ]; then exit 0;
	else exit 6; fi; }
test -r "$GITBUCKET_CONFIG" || { echo "$GITBUCKET_CONFIG not readable. Perhaps you forgot 'sudo'?";
	if [ "$1" = "stop" ]; then exit 0;
	else exit 6; fi; }

# Source function library.
. /etc/init.d/functions

# Read config
[ -f "$GITBUCKET_CONFIG" ] && . "$GITBUCKET_CONFIG"

# Set up environment accordingly to the configuration settings
[ -n "$GITBUCKET_HOME" ] || { echo "GITBUCKET_HOME not configured in $GITBUCKET_CONFIG";
	if [ "$1" = "stop" ]; then exit 0;
	else exit 6; fi; }
[ -d "$GITBUCKET_HOME" ] || { echo "GITBUCKET_HOME directory does not exist: $GITBUCKET_HOME";
	if [ "$1" = "stop" ]; then exit 0;
	else exit 1; fi; }


JAVA_CMD="$GITBUCKET_JAVA_CMD $GITBUCKET_JAVA_OPTIONS -jar $GITBUCKET_WAR"
PARAMS=""
[ -n "$GITBUCKET_PORT" ] && PARAMS="$PARAMS --port=$GITBUCKET_PORT"
[ -n "$GITBUCKET_PREFIX" ] && PARAMS="$PARAMS --prefix=$GITBUCKET_PREFIX"
[ -n "$GITBUCKET_HOST" ] && PARAMS="$PARAMS --host=$GITBUCKET_HOST"
[ -n "$GITBUCKET_HOME" ] && PARAMS="$PARAMS --gitbucket.home=$GITBUCKET_HOME"
[ -n "$GITBUCKET_ARGS" ] && PARAMS="$PARAMS $GITBUCKET_ARGS"

JAVA_PID_FILE="$GITBUCKET_HOME/java.pid"

# start process
$JAVA_CMD $PARAMS &

PID=$!
RETVAL=$?

echo "$PID" > "$JAVA_PID_FILE"

exit $RETVAL
