include:
  - openstack.neutron.config
  - openstack.neutron.linuxbridge_agent
  - openstack.neutron.init

neutron-server:
  pkg.installed:
    - names:
      - openstack-neutron
      - openstack-neutron-ml2
      - python-neutronclient
      - openstack-neutron-linuxbridge
  file.managed:
    - name: /etc/init.d/neutron-server
    - source: salt://openstack/neutron/files/neutron-server
    - mode: 755
    - user: root
    - group: root
  service.running:
    - name: neutron-server
    - enable: True
    - watch:
      - file: /etc/neutron
    - require:
      - cmd: neutron-init
      - pkg: neutron-server
