include:
  - openstack.cinder.config
  - openstack.cinder.nfs

cinder-server:
  pkg.installed:
    - names:
      - openstack-cinder
      - python-cinderclient
  file.managed:
    - name: /etc/init.d/

/usr/local/bin/cinder_data.sh:
  file.managed:
    - source: salt://openstack/cinder/files/cinder_data.sh
    - mode: 755
    - user: root
    - group: root
    - template: jinja
    - defaults:
      ADMIN_PASSWD: {{ pillar['cinder']['ADMIN_PASSWD'] }} 
      ADMIN_TOKEN: {{ pillar['cinder']['ADMIN_TOKEN'] }}
      CONTROL_IP: {{ pillar['cinder']['CONTROL_IP'] }}

cinder-keystone-init:
  cmd.run:
    - name: bash /usr/local/bin/cinder_data.sh && touch /etc/cinder-datainit.lock
    - require:
      - file: /usr/local/bin/cinder_data.sh
    - unless: test -f /etc/cinder-datainit.lock

cinder-db-init:
  cmd.run:
    - name: cinder-manage db sync && touch /etc/cinder-db-sync.lock
    - require:
      - mysql_grants: cinder-mysql
    - unless: test -f /etc/cinder-db-sync.lock

openstack-cinder-api:
  file.managed:
    - name: /etc/init.d/openstack-cinder-api
    - source: salt://openstack/cinder/files/openstack-cinder-api
    - mode: 755
    - user: root
    - group: root
  cmd.run:
    - name: chkconfig --add openstack-cinder-api
    - unless: chkconfig --list | grep openstack-cinder-api
    - require:
      - file: openstack-cinder-api
  service.running:
    - enable: True
    - watch:
      - file: /etc/cinder/api-paste.ini
      - file: /etc/cinder/policy.json
      - file: /etc/cinder/rootwrap.conf
      - file: /etc/cinder/rootwrap.d
      - file: /etc/cinder/cinder.conf
      - file: openstack-cinder-api
    - require:
      - cmd: cinder-keystone-init
      - cmd: openstack-cinder-api
      - cmd: cinder-db-init
      - file: /var/log/cinder
      - file: /var/lib/cinder

openstack-cinder-scheduler:
  file.managed:
    - name: /etc/init.d/openstack-cinder-scheduler
    - source: salt://openstack/cinder/files/openstack-cinder-scheduler
    - mode: 755
    - user: root
    - group: root
  cmd.run:
    - name: chkconfig --add openstack-cinder-scheduler
    - unless: chkconfig --list | grep openstack-cinder-scheduler
    - require:
      - file: openstack-cinder-scheduler
  service.running:
    - enable: True
    - watch:
      - file: /etc/cinder/api-paste.ini
      - file: /etc/cinder/policy.json
      - file: /etc/cinder/rootwrap.conf
      - file: /etc/cinder/rootwrap.d
      - file: /etc/cinder/cinder.conf
      - file: openstack-cinder-scheduler
    - require:
      - cmd: cinder-keystone-init
      - cmd: openstack-cinder-scheduler
      - cmd: cinder-db-init
      - file: /var/log/cinder
      - file: /var/lib/cinder

openstack-cinder-volume:
  file.managed:
    - name: /etc/init.d/openstack-cinder-volume
    - source: salt://openstack/cinder/files/openstack-cinder-volume
    - mode: 755
    - user: root
    - group: root
  cmd.run:
    - name: chkconfig --add openstack-cinder-volume
    - unless: chkconfig --list | grep openstack-cinder-volume
    - require:
      - file: openstack-cinder-volume
  service.running:
    - enable: True
    - watch:
      - file: /etc/cinder/api-paste.ini
      - file: /etc/cinder/policy.json
      - file: /etc/cinder/rootwrap.conf
      - file: /etc/cinder/rootwrap.d
      - file: /etc/cinder/cinder.conf
      - file: openstack-cinder-volume
    - require:
      - cmd: cinder-keystone-init
      - cmd: openstack-cinder-volume
      - cmd: cinder-db-init
      - file: /var/log/cinder
      - file: /var/lib/cinder
