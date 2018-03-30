neutron-mysql:
  mysql_database.present:
    - name: {{ pillar['neutron']['NEUTRON_DB_NAME'] }}
    - require:
      - service: mysql-server
  mysql_user.present:
    - name: {{ pillar['neutron']['NEUTRON_DB_USER'] }}
    - host: {{ pillar['neutron']['HOST_ALLOW'] }}
    - password: {{ pillar['neutron']['NEUTRON_DB_PASS'] }}
    - require:
      - mysql_database: neutron-mysql
  mysql_grants.present:
    - grant: all
    - database: {{ pillar['neutron']['DB_ALLOW'] }}
    - user: {{ pillar['neutron']['NEUTRON_DB_USER'] }}
    - host: {{ pillar['neutron']['HOST_ALLOW'] }}
    - require:
      - mysql_user: neutron-mysql
