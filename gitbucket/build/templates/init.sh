#!/bin/sh

service gitbucket start

chown gitbucket:gitbucket /var/lib/gitbucket

cat <<EOF >>~/.bashrc
trap 'service gitbucket stop; exit 0' TERM
EOF
exec /bin/bash
