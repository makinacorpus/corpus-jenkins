{% import "makina-states/services/monitoring/circus/macros.jinja" as circus  with context %}
{% set cfg = opts['ms_project'] %}
{% set data = cfg.data %}
{% import "makina-states/_macros/h.jinja" as h with context %}
include:
  - makina-states.services.monitoring.circus

{% macro varsh() %}
    - defaults:
        cid: {{cfg.name}}
{% endmacro%}
{{h.deliver_config_files(data.configs, after_macro=varsh)}}

# our wrapper drop privs after setting ulimits
{% set circus_data = {
     'cmd': cfg.data_root+'/launcher.sh',
     'uid': cfg.user,
     'gid': cfg.group,
     'force_restart': true,
     'copy_env': True,
     'working_dir': data.var,
     'warmup_delay': "30",
     'max_age': 24*60*60} %}
{{ circus.circusAddWatcher(cfg.name, **circus_data) }}
