nfs-install:
  pkg.installed:
    - names:
      - nfs-utils
      - rpcbind
  service.running:
    - name: nfs
    - enable: True
    - require:
      - file: /etc/exports

rpcbind:
  service.running:
    - enable: True
    - require:
      - service: nfs

/data/nfs:
  file.directory:
    - user: root
    - group: root
    - makedirs: True

/etc/exports:
  file.managed:
    - source: salt://openstack/cinder/files/exports
    - uesr: root
    - group: root
    - mode: 644

/etc/cinder/nfs_shares:
  file.managed:
    - source: salt://openstack/cinder/files/nfs_shares
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - defaults: 
      NFS_IP: {{ pillar['cinder']['NFS_IP'] }}
