include:
  - openstack.glance.init
glance-install:
  pkg.installed:
    - names:
      - openstack-glance 
      - python-glanceclient
    - require: 
      - file: rdo_repo

/etc/glance:
  file.recurse:
    - source: salt://openstack/glance/files/config
    - user: glance
    - group: glance
    - template: jinja
    - defaults:
      MYSQL_SERVER: {{ pillar['keystone']['MYSQL_SERVER'] }}
      GLANCE_DB_PASS: {{ pillar['glance']['GLANCE_DB_PASS'] }}
      GLANCE_DB_USER: {{ pillar['glance']['GLANCE_DB_USER'] }}
      GLANCE_DB_NAME: {{ pillar['glance']['GLANCE_DB_NAME'] }}
      RABBITMQ_HOST: {{ pillar['rabbit']['RABBITMQ_HOST'] }}
      RABBITMQ_PORT: {{ pillar['rabbit']['RABBITMQ_PORT'] }}
      RABBITMQ_USER: {{ pillar['rabbit']['RABBITMQ_USER'] }}
      RABBITMQ_PASS: {{ pillar['rabbit']['RABBITMQ_PASS'] }}
      AUTH_KEYSTONE_HOST: {{ pillar['glance']['AUTH_KEYSTONE_HOST'] }}
      AUTH_KEYSTONE_PORT: {{ pillar['glance']['AUTH_KEYSTONE_PORT'] }}
      AUTH_KEYSTONE_PROTOCOL: {{ pillar['glance']['AUTH_KEYSTONE_PROTOCOL'] }}
      AUTH_GLANCE_ADMIN_TENANT: {{ pillar['glance']['AUTH_GLANCE_ADMIN_TENANT'] }}
      AUTH_GLANCE_ADMIN_USER: {{ pillar['glance']['AUTH_GLANCE_ADMIN_USER'] }}
      AUTH_GLANCE_ADMIN_PASS: {{ pillar['glance']['AUTH_GLANCE_ADMIN_PASS'] }}

glance-db-sync:
  cmd.run:
    - name: yum install -y python-crypto && glance-manage db_sync && touch /etc/glance-datasync.lock && chown glance:glance /var/log/glance/*
    - require:
      - mysql_grants: glance-mysql
      - pkg: glance-install
    - unless: test -f /etc/glance-datasync.lock

openstack-glance-api:
  file.managed:
    - name: /etc/init.d/openstack-glance-api
    - source: salt://openstack/glance/files/openstack-glance-api
    - mode: 755
    - user: root
    - group: root
  service:
    - running
    - enable: True
    - watch: 
      - file: /etc/glance
    - require:
      - pkg: glance-install
      - cmd: glance-db-sync

openstack-glance-registry:
  file.managed:
    - name: /etc/init.d/openstack-glance-registry
    - source: salt://openstack/glance/files/openstack-glance-registry
    - mode: 755
    - user: root
    - group: root
  service:
    - running
    - enable: True
    - watch:
      - file: /etc/glance
    - require:
      - pkg: glance-install
      - cmd: glance-db-sync
