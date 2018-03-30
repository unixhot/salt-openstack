openstack-neutron-dhcp-agent:
  file.managed:
    - name: /etc/init.d/openstack-neutron-dhcp-agent
    - source: salt://openstack/neutron/files/openstack-neutron-dhcp-agent
    - mode: 755
    - user: root
    - group: root
  cmd.run:
    - name: chkconfig --add openstack-neutron-dhcp-agent
    - unless: chkconfig --list | grep openstack-neutron-dhcp-agent
    - require:
      - file: openstack-neutron-dhcp-agent
  service.disabled:
    - enable: False
