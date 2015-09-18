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
