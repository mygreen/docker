#!/bin/sh
#
#     GitBucket startup script
#

GITBUCKET_LIB="/usr/lib/gitbucket"
GITBUCKET_WAR="$GITBUCKET_LIB/gitbucket.war"
GITBUCKET_CONFIG="$GITBUCKET_LIB/gitbucket.conf"
GITBUCKET_PID_FILE="/var/run/gitbucket.pid"

test -r "$GITBUCKET_CONFIG" || { echo "$GITBUCKET_CONFIG not readable. Perhaps you forgot 'sudo'?";
    if [ "$1" = "stop" ]; then exit 0;
    else exit 6; fi; }

# Source function library.
. /etc/init.d/functions

# Read config
[ -f "$GITBUCKET_CONFIG" ] && . "$GITBUCKET_CONFIG"

JAVA_PID_FILE=$GITBUCKET_HOME/java.pid

RETVAL=0

case "$1" in
    start)
        echo -n "Starting GitBucket "
        daemon --check gitbucket --user "$GITBUCKET_USER" --pidfile "$GITBUCKET_PID_FILE" $GITBUCKET_LIB/startup.sh > /dev/null
        RETVAL=$?
        
        if [ $RETVAL = 0 ]; then
            echo `cat $JAVA_PID_FILE` > $GITBUCKET_PID_FILE
            success
            echo > "$GITBUCKET_PID_FILE"  # just in case we fail to find it
                MY_SESSION_ID=`/bin/ps h -o sess -p $$`
                # get PID
                /bin/ps hww -u "$GITBUCKET_USER" -o sess,ppid,pid,cmd | \
                while read sess ppid pid cmd; do
            [ "$ppid" = 1 ] || continue
            # this test doesn't work because GitBucket sets a new Session ID
                    # [ "$sess" = "$MY_SESSION_ID" ] || continue
                echo "$cmd" | grep $GITBUCKET_WAR > /dev/null
            [ $? = 0 ] || continue
            # found a PID
            echo $pid > "$GITBUCKET_PID_FILE"
            done
        else
            failure
        fi
        echo
    ;;
    stop)
        echo -n "Shutting down Gitbucket "
        killproc gitbucket
        RETVAL=$?
        echo
    ;;
    try-restart|condrestart)
        if test "$1" = "condrestart"; then
            echo "${attn} Use try-restart ${done}(LSB)${attn} rather than condrestart ${warn}(RH)${norm}"
        fi
        $0 status
        if test $? = 0; then
            $0 restart
        else
            : # Not running is not a failure.
        fi
    ;;
    restart)
        $0 stop
        $0 start
    ;;
    force-reload)
        echo -n "Reload service GitBucket "
        $0 try-restart
    ;;
    reload)
        $0 restart
    ;;
    status)
        status gitbucket
        RETVAL=$?
    ;;
    probe)
        ## Optional: Probe for the necessity of a reload, print out the
        ## argument to this init script which is required for a reload.
        ## Note: probe is not (yet) part of LSB (as of 1.9)
        
        test "$GITBUCKET_CONFIG" -nt "$GITBUCKET_PID_FILE" && echo reload
    ;;
    *)
        echo "Usage: $0 {start|stop|status|try-restart|restart|force-reload|reload|probe}"
        exit 1
    ;;
esac
exit $RETVAL
