include:
  - openstack.mysql.init

mysql-server:
  pkg.installed:
    - name: mysql-server

  file.managed:
    - name: /etc/my.cnf
    - source: salt://openstack/mysql/files/my.cnf

  service.running:
    - name: mysqld
    - enable: True
    - require:
      - pkg: mysql-server
    - watch:
      - file: mysql-server
