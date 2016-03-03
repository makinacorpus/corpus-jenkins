#!/usr/bin/env bash
{% set cfg = salt['mc_project.get_configuration'](cid) %}
for i in /etc/default/jenkins "{{cfg.data_root}}/jenkins-default";do
    if test -r "${i}";then
        source "${i}"
    fi
done
{% for i,val in cfg.data.env.items() %}
{{i}}="{{val}}"
export {{i}}
{% endfor %}
# vim:set et sts=4 ts=4 tw=80:
