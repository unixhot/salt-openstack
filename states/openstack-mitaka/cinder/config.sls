/etc/cinder/cinder.conf:
  file.managed:
    - source: salt://openstack/cinder/files/cinder.conf
    - mode: 644
    - user: root
    - group: root
    - template: jinja
    - defaults:
      RABBITMQ_HOST: {{ pillar['cinder']['RABBITMQ_HOST'] }}
      RABBITMQ_PORT: {{ pillar['cinder']['RABBITMQ_PORT'] }}
      RABBITMQ_USER: {{ pillar['cinder']['RABBITMQ_USER'] }}
      RABBITMQ_PASS: {{ pillar['cinder']['RABBITMQ_PASS'] }}
      AUTH_KEYSTONE_HOST: {{ pillar['cinder']['AUTH_KEYSTONE_HOST'] }}
      AUTH_KEYSTONE_PORT: {{ pillar['cinder']['AUTH_KEYSTONE_PORT'] }}
      AUTH_KEYSTONE_PROTOCOL: {{ pillar['cinder']['AUTH_KEYSTONE_PROTOCOL'] }}
      AUTH_ADMIN_PASS: {{ pillar['cinder']['AUTH_ADMIN_PASS'] }}
      CONTROL_IP: {{ pillar['cinder']['CONTROL_IP'] }}
      MYSQL_SERVER: {{ pillar['cinder']['MYSQL_SERVER'] }}
      CINDER_USER: {{ pillar['cinder']['CINDER_USER'] }}
      CINDER_PASS: {{ pillar['cinder']['CINDER_PASS'] }}
      CINDER_DBNAME: {{ pillar['cinder']['CINDER_DBNAME'] }}
