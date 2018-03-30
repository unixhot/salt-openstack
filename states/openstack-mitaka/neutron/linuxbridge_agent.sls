include:
  - openstack.neutron.config

neutron-linuxbridge-agent:
  pkg.installed:
    - names:
      - openstack-neutron
      - openstack-neutron-ml2
      - python-neutronclient
      - openstack-neutron-linuxbridge
  file.managed:
    - name: /etc/init.d/neutron-linuxbridge-agent
    - source: salt://openstack/neutron/files/neutron-linuxbridge-agent
    - mode: 755
    - user: root
    - group: root
  service.running:
    - name: neutron-linuxbridge-agent
    - enable: True
    - watch:
      - file: /etc/neutron
      - file: neutron-linuxbridge-agent
    - require:
      - pkg: neutron-linuxbridge-agent
