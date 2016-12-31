#!/bin/sh

service jenkins start

chown jenkins:jenkins /var/lib/jenkins

cat <<EOF >>~/.bashrc
trap 'service jenkins stop; exit 0' TERM
EOF
exec /bin/bash
