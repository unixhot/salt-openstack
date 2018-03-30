include:
  - openstack.nova.config
  - openstack.nova.init

nova-control-install:
  pkg.installed:
    - names:
      - openstack-nova-api
      - openstack-nova-cert
      - openstack-nova-conductor
      - openstack-nova-console
      - openstack-nova-novncproxy
      - openstack-nova-scheduler
      - python-novaclient
    - require:
      - file: rdo_repo

nova-db-sync:
  cmd.run:
    - name: nova-manage db sync && touch /etc/nova-dbsync.lock && chown nova:nova /var/log/nova/*
    - require:
      - mysql_grants: nova-mysql
      - pkg: nova-control-install
    - unless: test -f /etc/nova-dbsync.lock

nova-api-service:
  file.managed:
    - name: /etc/init.d/openstack-nova-api
    - source: salt://openstack/nova/files/openstack-nova-api
    - user: root
    - group: root
    - mode: 755
  service.running:
    - name: openstack-nova-api
    - enable: True
    - watch:
      - file: /etc/nova
    - require:
      - pkg: nova-control-install
      - cmd: nova-db-sync

nova-cert-service:
  file.managed:
    - name: /etc/init.d/openstack-nova-cert
    - source: salt://openstack/nova/files/openstack-nova-cert
    - user: root
    - group: root
    - mode: 755
  service.running:
    - name: openstack-nova-cert
    - enable: True
    - watch:
      - file: /etc/nova
    - require:
      - pkg: nova-control-install
      - cmd: nova-db-sync

nova-conductor-service:
  file.managed:
    - name: /etc/init.d/openstack-nova-conductor
    - source: salt://openstack/nova/files/openstack-nova-conductor
    - user: root
    - group: root
    - mode: 755
  service.running:
    - name: openstack-nova-conductor
    - enable: True
    - watch:
      - file: /etc/nova
    - require:
      - pkg: nova-control-install
      - cmd: nova-db-sync

nova-consoleauth-service:
  file.managed:
    - name: /etc/init.d/openstack-nova-consoleauth
    - source: salt://openstack/nova/files/openstack-nova-consoleauth
    - user: root
    - group: root
    - mode: 755
  service.running:
    - name: openstack-nova-consoleauth
    - enable: True
    - watch:
      - file: /etc/nova
    - require:
      - pkg: nova-control-install
      - cmd: nova-db-sync

nova-novncproxy-service:
  file.managed:
    - name: /etc/init.d/openstack-nova-novncproxy
    - source: salt://openstack/nova/files/openstack-nova-novncproxy
    - user: root
    - group: root
    - mode: 755
  service.running:
    - name: openstack-nova-novncproxy
    - enable: True
    - watch:
      - file: /etc/nova
    - require:
      - pkg: nova-control-install
      - cmd: nova-db-sync

nova-scheduler-service:
  file.managed:
    - name: /etc/init.d/openstack-nova-scheduler
    - source: salt://openstack/nova/files/openstack-nova-scheduler
    - user: root
    - group: root
    - mode: 755
  service.running:
    - name: openstack-nova-scheduler
    - enable: True
    - watch:
      - file: /etc/nova
    - require:
      - pkg: nova-control-install
      - cmd: nova-db-sync
