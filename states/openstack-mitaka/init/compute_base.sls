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
