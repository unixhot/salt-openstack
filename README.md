# SaltStack 自动化部署OpenStack Stein
前言
====

**诞生记**
    - 首先：之前编写了SaltStack自动化部署OpenStackI版：使用的源码包的方式
    - 因为：有用户反映安装起来比较繁琐，加上pip源网络的问题，很多朋友自动化部署有问题。
    - 所以：本次重新使用yum安装的方式重新编写了一遍，2019年更新到了Stein版本。
    - 最后：如有建议欢迎反馈。QQ：57459267

**友情提示**

- 本文的使用对象为熟悉OpenStack，可以手动完成OpenStack的部署的用户。如果不熟悉OpenStack的用户，可以参考我录制的
  - 《基于SaltStack的自动化运维实践》课程: [http://www.devopsedu.com/front/couinfo/49]
  - 《基于OpenStack构建企业私有云实践》课程: [http://www.devopsedu.com/front/couinfo/101]

使用方式
====

**1.OpenStack架构**

![架构图](https://github.com/unixhot/saltstack-openstack/blob/master/openstack-arch.png)  

**2.介绍**

    - 1.每个服务均有一个目录存放SLS文件。每个目录下均有files目录，用来存放模板文件和脚本。
    - 2.每个服务均有一个Pillar文件，主要定义和配置相关的如IP地址、网络接口、用户名和密码等。

**使用步骤**

## 1.系统初始化(必备)

1.1 设置主机名！！！
```
[root@linux-node1 ~]# cat /etc/hostname 
linux-node1.example.com

[root@linux-node2 ~]# cat /etc/hostname 
linux-node2.example.com

[root@linux-node3 ~]# cat /etc/hostname 
linux-node3.example.com

```
1.2 设置/etc/hosts保证主机名能够解析
```
[root@linux-node1 ~]# cat /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
192.168.56.11 linux-node1 linux-node1.example.com
192.168.56.12 linux-node2 linux-node2.example.com
192.168.56.13 linux-node3 linux-node3.example.com

```
1.3 关闭SELinux和防火墙
```
[root@linux-node1 ~]# vim /etc/sysconfig/selinux
SELINUX=disabled #修改为disabled
```

1.4 关闭NetworkManager和防火墙开启自启动
```
[root@linux-node1 ~]# systemctl disable firewalld
[root@linux-node1 ~]# systemctl disable NetworkManager
```

## 2.安装Salt-SSH并克隆本项目代码。

2.1 设置部署节点到其它所有节点的SSH免密码登录（包括本机）
```bash
[root@linux-node1 ~]# ssh-keygen -t rsa
[root@linux-node1 ~]# ssh-copy-id linux-node1
[root@linux-node1 ~]# ssh-copy-id linux-node2
[root@linux-node1 ~]# ssh-copy-id linux-node3
```

2.2 安装Salt SSH（注意：老版本的Salt SSH不支持Roster定义Grains，需要2017.7.4以上版本）
```
[root@linux-node1 ~]# yum install https://mirrors.aliyun.com/epel/epel-release-latest-7.noarch.rpm
[root@linux-node1 ~]# yum install -y https://mirrors.aliyun.com/saltstack/yum/redhat/salt-repo-latest-2.el7.noarch.rpm
[root@linux-node1 ~]# sed -i "s/repo.saltstack.com/mirrors.aliyun.com\/saltstack/g" /etc/yum.repos.d/salt-latest.repo
[root@linux-node1 ~]# yum install -y salt-ssh git unzip
```

2.3 设置SaltStack管理其它节点
```ObjectiveC
[root@linux-node1 ~]# vim /etc/salt/roster 
linux-node1:
  host: 192.168.56.11
  user: root
  priv: /root/.ssh/id_rsa

linux-node2:
  host: 192.168.56.12
  user: root
  priv: /root/.ssh/id_rsa
```

2.4 设置状态文件存放目录
```
[root@linux-node1 ~]# vim /etc/salt/master
file_roots:
  base:
    - /srv/salt/

pillar_roots:
  base:
    - /srv/pillar
[root@linux-node1 ~]# mkdir -p /srv/{salt,pillar}

```

2.5 克隆项目代码
```
# git clone https://github.com/unixhot/salt-openstack.git
# cd salt-openstack/
```


**2.修改Pillar目录的各个服务的配置**

**3.修改top.sls**

**All-In-One(所有服务均安装在一台服务器)**

```ObjectiveC
base:
  '*':
    - openstack.all-in-one
```

***控制节点+计算节点***

```ObjectiveC
base:
  'control':
      - openstack.control
  'compute':
      - openstack.compute
```

***多节点***

```ObjectiveC
base:
  'mysql':
    - openstack.mysql.server
  'rabbitmq':
    - openstack.rabbitmq-server
  'keystone':
    - openstack.keystone.server
  'glance':
    - openstack.glance.server
  'nova-control':
    - openstack.nova.control
  'nova-compute':
    - openstack.nova.compute
    - openstack.neutron.linuxbridge_agent
  'neutron-server':
    - openstack.neutron.server
  'cinder-server':
    - opensack.cinder.server
  'horizon':
    - openstack.horizon.server

##已知Bug

* Neutron的neutron.conf需要获取service的tenant id后，手动设置
    keystone tenant-list | awk '/ service / { print $2 }'
    nova_admin_tenant_id =
    
  
