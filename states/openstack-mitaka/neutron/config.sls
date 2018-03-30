/etc/neutron:
  file.recurse:
    - source: salt://openstack/neutron/files/config
    - user: neutron
    - group: neutron
    - template: jinja
    - defaults:
      MYSQL_SERVER: {{ pillar['neutron']['MYSQL_SERVER'] }}
      NEUTRON_IP: {{ pillar['neutron']['NEUTRON_IP'] }}
      NEUTRON_DB_NAME: {{ pillar['neutron']['NEUTRON_DB_NAME'] }}
      NEUTRON_DB_USER: {{ pillar['neutron']['NEUTRON_DB_USER'] }}
      NEUTRON_DB_PASS: {{ pillar['neutron']['NEUTRON_DB_PASS'] }}
      AUTH_KEYSTONE_HOST: {{ pillar['neutron']['AUTH_KEYSTONE_HOST'] }}
      AUTH_KEYSTONE_PORT: {{ pillar['neutron']['AUTH_KEYSTONE_PORT'] }}
      AUTH_KEYSTONE_PROTOCOL: {{ pillar['neutron']['AUTH_KEYSTONE_PROTOCOL'] }}
      AUTH_ADMIN_PASS: {{ pillar['neutron']['AUTH_ADMIN_PASS'] }}
      NOVA_URL: {{ pillar['neutron']['NOVA_URL'] }}
      NOVA_ADMIN_USER: {{ pillar['neutron']['NOVA_ADMIN_USER'] }}
      NOVA_ADMIN_PASS: {{ pillar['neutron']['NOVA_ADMIN_PASS'] }}
      NOVA_ADMIN_TENANT: {{ pillar['neutron']['NOVA_ADMIN_TENANT'] }}
      NOVA_ADMIN_AUTH_URL: {{ pillar['neutron']['NOVA_ADMIN_AUTH_URL'] }}
      RABBITMQ_HOST: {{ pillar['rabbit']['RABBITMQ_HOST'] }}
      RABBITMQ_PORT: {{ pillar['rabbit']['RABBITMQ_PORT'] }}
      RABBITMQ_USER: {{ pillar['rabbit']['RABBITMQ_USER'] }}
      RABBITMQ_PASS: {{ pillar['rabbit']['RABBITMQ_PASS'] }}
      AUTH_NEUTRON_ADMIN_TENANT: {{ pillar['neutron']['AUTH_NEUTRON_ADMIN_TENANT'] }}
      AUTH_NEUTRON_ADMIN_USER: {{ pillar['neutron']['AUTH_NEUTRON_ADMIN_USER'] }}
      AUTH_NEUTRON_ADMIN_PASS: {{ pillar['neutron']['AUTH_NEUTRON_ADMIN_PASS'] }}
      VM_INTERFACE: {{ pillar['neutron']['VM_INTERFACE'] }}
