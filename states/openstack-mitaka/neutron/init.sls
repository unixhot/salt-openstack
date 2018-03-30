neutron-init:
  file.managed:
    - name: /usr/local/bin/neutron_init.sh
    - source: salt://openstack/neutron/files/neutron_init.sh
    - mode: 755
    - user: root
    - group: root
    - template: jinja
    - defaults:
      KEYSTONE_ADMIN_TENANT: {{ pillar['keystone']['KEYSTONE_ADMIN_TENANT'] }}
      KEYSTONE_ADMIN_USER: {{ pillar['keystone']['KEYSTONE_ADMIN_USER'] }}
      KEYSTONE_ADMIN_PASSWD: {{ pillar['keystone']['KEYSTONE_ADMIN_PASSWD'] }}
      KEYSTONE_AUTH_URL: {{ pillar['keystone']['KEYSTONE_AUTH_URL'] }}
      NEUTRON_IP: {{ pillar['neutron']['NEUTRON_IP'] }}
      AUTH_NEUTRON_ADMIN_TENANT: {{ pillar['neutron']['AUTH_NEUTRON_ADMIN_TENANT'] }}
      AUTH_NEUTRON_ADMIN_USER: {{ pillar['neutron']['AUTH_NEUTRON_ADMIN_USER'] }}
      AUTH_NEUTRON_ADMIN_PASS: {{ pillar['neutron']['AUTH_NEUTRON_ADMIN_PASS'] }}
  cmd.run:
    - name: bash /usr/local/bin/neutron_init.sh && touch /etc/neutron-datainit.lock
    - require:
      - file: /usr/local/bin/neutron_init.sh
    - unless: test -f /etc/neutron-datainit.lock
