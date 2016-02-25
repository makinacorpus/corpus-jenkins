{% set cfg = opts['ms_project'] %}
{% set data = cfg.data %}
include:
  - makina-projects.{{cfg.name}}.fixperms

{{cfg.name}}-remove-as-service:
  service.dead:
    - name: jenkins
    - enable: false
    - watch_in:
      - cmd: {{cfg.name}}-restricted-perms

{{cfg.name}}-create_root:
  cmd.run:
    - name: rsync -azv "/var/lib/jenkins/" "{{data.var}}/"
    - onlyif: test ! -e "{{data.var}}/jobs/"
    - watch_in:
      - cmd: {{cfg.name}}-restricted-perms

{{cfg.name}}-create_cache:
  cmd.run:
    - name: rsync -azv "/var/cache/jenkins/" "{{data.cache}}/"
    - onlyif: test ! -e "{{data.var}}/war/"
    - watch_in:
      - cmd: {{cfg.name}}-restricted-perms

{% if not data.get('no_ssh_shared_key', False) %}
{% for i in ['id_rsa', 'id_rsa.pub']%}
{{cfg.name}}-create_key-{{i}}:
  file.managed:
    - name: "{{cfg.data_root}}/{{i}}"
    - source: "/root/.ssh/{{i}}"
    - user: {{cfg.user}}
    - group: {{cfg.group}}
    - mode: 700
    - watch_in:
      - cmd: {{cfg.name}}-restricted-perms
{% endfor%}
{% endif%}

{#
{{cfg.name}}-create_root-de:
  file.managed:
    - name: "{{cfg.data_root}}/jenkins-default"
    - source: "/etc/default/jenkins"
    - onlyif: test ! -e  "{{cfg.data_root}}/jenkins-default"
    - user: {{cfg.user}}
    - group: {{cfg.group}}
    - mode: 755
    - watch_in:
      - cmd: {{cfg.name}}-restricted-perms
#}

{{cfg.name}}-create_root-d:
  file.absent:
    - name: /var/lib/jenkins
    - onlyif: test -e /var/lib/jenkins && test ! -h /var/lib/jenkins
    - watch:
      - cmd: {{cfg.name}}-create_root

{{cfg.name}}-create_root-l:
  file.symlink:
    - name: /var/lib/jenkins
    - target: {{data.var}}
    - watch:
      - file: {{cfg.name}}-create_root-d

{{cfg.name}}-create_cache-d:
  file.absent:
    - name: /var/cache/jenkins
    - onlyif: test -e /var/cache/jenkins && test ! -h /var/lib/cache
    - watch:
      - cmd: {{cfg.name}}-create_cache

{{cfg.name}}-create_cache-l:
  file.symlink:
    - name: /var/cache/jenkins
    - target: {{data.cache}}
    - watch:
      - file: {{cfg.name}}-create_cache-d
 
