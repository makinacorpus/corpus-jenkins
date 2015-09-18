#!/usr/bin/env bash
. /etc/default/jenkins
{% set cfg = salt['mc_project.get_configuration'](cid) %}
{% for i,val in cfg.data.env.items() %}
{{i}}="{{val}}"
export {{i}}
{% endfor %}
# vim:set et sts=4 ts=4 tw=80:
