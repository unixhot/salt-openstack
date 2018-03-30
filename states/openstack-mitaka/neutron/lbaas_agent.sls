neutron-lbaas-agent:
  pkg.installed:
    - name: haproxy
  file.managed:
    - name: /etc/init.d/neutron-lbaas-agent
    - source: salt://openstack/neutron/files/config/neutron-lbaas-agent
    - mode: 755
    - user: root
    - group: root
  service.running:
    - enable: True
    - watch:
      - file: /etc/neutron
    - require:
      - cmd: neutron-lbaas-agent
      - file: neutron-lbaas-agent
