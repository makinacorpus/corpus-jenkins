#!/usr/bin/env bash
{% set cfg = salt['mc_project.get_configuration'](cid) %}
set -x
. $(dirname $0)/env.sh
if [ -n "$MAXOPENFILES" ]; then
    [ "$VERBOSE" != no ] && echo Setting up max open files limit to $MAXOPENFILES
    ulimit -n $MAXOPENFILES
fi
# forward all local env to environment
for i in $(set|cut -d= -f-1|egrep -v "^_$");do
    export "${i}"
done
exec $JAVA $JAVA_ARGS -jar $JENKINS_WAR $JENKINS_ARGS
# vim:set et sts=4 ts=4 tw=80:
