nova-init:
  file.managed:
    - name: /usr/local/bin/nova_init.sh
    - source: salt://openstack/nova/files/nova_init.sh
    - mode: 755
    - user: root
    - group: root
    - template: jinja
    - defaults:
      KEYSTONE_ADMIN_TENANT: {{ pillar['keystone']['KEYSTONE_ADMIN_TENANT'] }}
      KEYSTONE_ADMIN_USER: {{ pillar['keystone']['KEYSTONE_ADMIN_USER'] }}
      KEYSTONE_ADMIN_PASSWD: {{ pillar['keystone']['KEYSTONE_ADMIN_PASSWD'] }}
      KEYSTONE_AUTH_URL: {{ pillar['keystone']['KEYSTONE_AUTH_URL'] }}
      NOVA_IP: {{ pillar['nova']['NOVA_IP'] }}
      AUTH_NOVA_ADMIN_TENANT: {{ pillar['nova']['AUTH_NOVA_ADMIN_TENANT'] }}
      AUTH_NOVA_ADMIN_USER: {{ pillar['nova']['AUTH_NOVA_ADMIN_USER'] }}
      AUTH_NOVA_ADMIN_PASS: {{ pillar['nova']['AUTH_NOVA_ADMIN_PASS'] }}
  cmd.run:
    - name: bash /usr/local/bin/nova_init.sh && touch /etc/nova-datainit.lock
    - require:
      - file: nova-init
    - unless: test -f /etc/nova-datainit.lock
