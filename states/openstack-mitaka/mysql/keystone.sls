keystone-mysql:
  mysql_database.present:
    - name: {{ pillar['keystone']['KEYSTONE_DB_NAME'] }}
    - require:
      - service: mysql-server
  mysql_user.present:
    - name: {{ pillar['keystone']['KEYSTONE_DB_USER'] }}
    - host: {{ pillar['keystone']['HOST_ALLOW'] }}
    - password: {{ pillar['keystone']['KEYSTONE_DB_PASS'] }}
    - require:
      - mysql_database: keystone-mysql
  mysql_grants.present:
    - grant: all
    - database: {{ pillar['keystone']['DB_ALLOW'] }}
    - user: {{ pillar['keystone']['KEYSTONE_DB_USER'] }}
    - host: {{ pillar['keystone']['HOST_ALLOW'] }}
    - require:
      - mysql_user: keystone-mysql
