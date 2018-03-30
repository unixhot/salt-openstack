include:
  - openstack.nova.config

messagebus:
  service.running:
    - name: messagebus
    - enable: True

libvirtd:
  pkg.installed:
    - names:
      - libvirt
      - libvirt-python
      - libvirt-client
  service.running:
    - name: libvirtd
    - enable: True

avahi-daemon:
  pkg.installed:
    - name: avahi
  service.running:
    - name: avahi-daemon
    - enable: True
    - require:
      - pkg: avahi-daemon

nova-compute-service:
  pkg.installed:
    - names:
      - openstack-nova-compute
      - sysfsutils
  service.running:
    - name: openstack-nova-compute
    - enable: True
    - watch:
      - file: /etc/nova
      - pkg: nova-compute-service
    - require:
      - service: messagebus
      - service: libvirtd
      - service: avahi-daemon
