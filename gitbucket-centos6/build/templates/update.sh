#!/bin/sh
#
# GitBucket update script
#
GITBUCKET_LIB="/usr/lib/gitbucket"
GITBUCKET_WAR="$GITBUCKET_LIB/gitbucket.war"
GITBUCKET_CONFIG="$GITBUCKET_LIB/gitbucket.conf"
GITBUCKET_PID_FILE="/var/run/gitbucket.pid"

# Source function library.
. /etc/init.d/functions

# Read config
[ -f "$GITBUCKET_CONFIG" ] && . "$GITBUCKET_CONFIG"

# check process
if [ -f "$GITBUCKET_PID_FILE" ]; then
	PID=`cat $GITBUCKET_PID_FILE`
else
	PID=""
fi

checkpid "$PID"
if [ "$PID" != "" -a "$?" == "0" ]; then
	echo "GitBucketのプロセス（PID=$PID）が起動しています。停止してから実行してください。"
	exit 1
fi

echo -n "新しいバージョンのGitBucketを入力してください(例. 4.1) > "
read NEW_VERSION
if [ "$NEW_VERSION" = "" ]; then
	echo "バージョンが入力されていません。処理を中止します。"
	exit 1
fi

echo "...新しいバージョンの媒体を取得します。"
DOWNLOAD_FILE="$GITBUCKET_HOME/gitbucket.war"
/bin/rm -f "$DOWNLOAD_FILE"
wget -O "$DOWNLOAD_FILE" https://github.com/takezoe/gitbucket/releases/download/${NEW_VERSION}/gitbucket.war

if [ $? -ne 0 ]; then
	echo "新しいバージョンをダウンロードするのに失敗しました。"
	exit
fi

/bin/rm -f "$GITBUCKET_WAR"
mv "$DOWNLOAD_FILE" "$GITBUCKET_WAR"
chown "$GITBUCKET_USER":"$GITBUCKET_USER" "$GITBUCKET_WAR"

echo "...アップデートが完了しました。GitBucketを起動してください。"

exit 0
