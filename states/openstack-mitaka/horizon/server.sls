openstack_dashboard:
  pkg.installed:
    - names:
      - httpd
      - mod_wsgi
      - memcached
      - python-memcached
      - openstack-dashboard
  file.managed:
    - name: /etc/openstack-dashboard/local_settings
    - source: salt://openstack/horizon/files/config/local_settings
    - user: apache
    - group: apache
    - template: jinja
    - defaults:
      ALLOWED_HOSTS: {{ pillar['horizon']['ALLOWED_HOSTS'] }}
      OPENSTACK_HOST: {{ pillar['horizon']['OPENSTACK_HOST'] }}
  service.running:
    - name: httpd
    - enable: True
    - reload: True
    - require:
      - pkg: openstack_dashboard
    - watch:
      - file: openstack_dashboard
