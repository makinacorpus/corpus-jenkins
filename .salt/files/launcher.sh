#!/usr/bin/env bash
{% set cfg = salt['mc_project.get_configuration'](cid) %}
set -x
. $(dirname $0)/env.sh
if [ -n "$MAXOPENFILES" ]; then
    [ "$VERBOSE" != no ] && echo Setting up max open files limit to $MAXOPENFILES
    ulimit -n $MAXOPENFILES
fi
exec $JAVA $JAVA_ARGS -jar $JENKINS_WAR $JENKINS_ARGS
# vim:set et sts=4 ts=4 tw=80:
