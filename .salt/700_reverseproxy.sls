{% set cfg = opts['ms_project'] %}
{% import "makina-states/services/http/nginx/init.sls" as nginx with context %}
include:
  - makina-states.services.http.nginx
{% set data = cfg.data %}

# incondentionnaly reboot nginx & fpm upon deployments
echo reboot:
  cmd.run:
    - watch_in:
      - mc_proxy: nginx-pre-restart-hook

{{nginx.virtualhost(data.domain,
                    data.www_dir,
                    vhost_basename=cfg.name,
                    server_aliases=data.server_aliases,
                    vh_top_source=data.nginx_top,
                    vh_content_source=data.nginx_vhost,
                    cfg=cfg.name) }}
