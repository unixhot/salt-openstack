include:
  - openstack.keystone.init

keystone-install:
  pkg.installed:
    - names:
      - openstack-keystone
      - python-keystoneclient
    - require: 
      - file: rdo_repo

/etc/keystone:
  file.recurse:
    - source: salt://openstack/keystone/files/config
    - user: keystone
    - group: keystone
    - template: jinja
    - defaults:
      KEYSTONE_ADMIN_TOKEN: {{ pillar['keystone']['KEYSTONE_ADMIN_TOKEN'] }}
      MYSQL_SERVER: {{ pillar['keystone']['MYSQL_SERVER'] }}
      KEYSTONE_DB_PASS: {{ pillar['keystone']['KEYSTONE_DB_PASS'] }}
      KEYSTONE_DB_USER: {{ pillar['keystone']['KEYSTONE_DB_USER'] }}
      KEYSTONE_DB_NAME: {{ pillar['keystone']['KEYSTONE_DB_NAME'] }}

keystone-pki-setup:
  cmd.run:
    - name: keystone-manage pki_setup --keystone-user keystone --keystone-group keystone && chown -R keystone:keystone /etc/keystone/ssl && chmod -R o-rwx /etc/keystone/ssl
    - require:
      - pkg: keystone-install
    - unless: test -d /etc/keystone/ssl

keystone-db-sync:
  cmd.run:
    - name: keystone-manage db_sync && touch /etc/keystone-datasync.lock && chown keystone:keystone /var/log/keystone/*
    - require:
      - mysql_grants: keystone-mysql
      - pkg: keystone-install
      - file: /etc/keystone
    - unless: test -f /etc/keystone-datasync.lock

openstack-keystone:
  file.managed:
    - name: /etc/init.d/openstack-keystone
    - source: salt://openstack/keystone/files/openstack-keystone
    - user: root
    - group: root
    - mode: 755
  service.running:
    - enable: True
    - reload: True
    - require:
      - pkg: keystone-install
    - watch:
      - file: /etc/keystone
      - cmd: keystone-db-sync

/root/keystone_admin:
  file.managed:
    - source: salt://openstack/keystone/files/keystone_admin
    - mode: 755
    - user: root
    - group: root
    - template: jinja
    - defaults:
      KEYSTONE_ADMIN_TENANT: {{ pillar['keystone']['KEYSTONE_ADMIN_TENANT'] }}
      KEYSTONE_ADMIN_USER: {{ pillar['keystone']['KEYSTONE_ADMIN_USER'] }}
      KEYSTONE_ADMIN_PASSWD: {{ pillar['keystone']['KEYSTONE_ADMIN_PASSWD'] }}
      KEYSTONE_AUTH_URL: {{ pillar['keystone']['KEYSTONE_AUTH_URL'] }}
