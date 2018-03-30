cinder-mysql:
  mysql_database.present:
    - name: {{ pillar['cinder']['CINDER_DBNAME'] }}
    - require:
      - service: mysql-server
  mysql_user.present:
    - name: {{ pillar['cinder']['CINDER_USER'] }}
    - host: {{ pillar['cinder']['HOST_ALLOW'] }}
    - password: {{ pillar['cinder']['CINDER_PASS'] }}
    - require:
      - mysql_database: cinder-mysql
  mysql_grants.present:
    - grant: all
    - database: {{ pillar['cinder']['DB_ALLOW'] }}
    - user: {{ pillar['cinder']['CINDER_USER'] }}
    - host: {{ pillar['cinder']['HOST_ALLOW'] }}
    - require:
      - mysql_user: cinder-mysql
