# Install and Configure Firewalld on Debian 10

Firewalld is a Linux firewall management tool with support for IPv4, IPv6, Ethernet bridges and ipset firewall settings.
Firewalld acts as a _front-end for the Linux kernel's_ **netfilter** framework.
It is a standard firewall management software for Linux Debian 10 distribution.

## Install

The firewalld package is available via apt-get.

```
sudo apt-get update
sudo apt-get install firewalld
```

A package details are:

````shell
$ apt-get policy firewalld
firewalld:
  Installed: 0.9.2-2
  Candidate: 0.9.2-2
  Version table:
 *** 0.9.2-2 500
        500 http://deb.debian.org/debian bullseye/main amd64 Packages
        100 /var/lib/dpkg/status
````

Check that the service is in running state.

```shell
$ sudo firewall-cmd --state
 running

$ systemctl status firewalld
● firewalld.service - firewalld - dynamic firewall daemon
     Loaded: loaded (/lib/systemd/system/firewalld.service; enabled; vendor preset: enabled)
     Active: active (running) since Oct 01 21:11:00 UTC; 12s ago
       Docs: man:firewalld(1)
   Main PID: 3317 (firewalld)
      Tasks: 2 (limit: 2340)
     Memory: 29.3M
        CPU: 868ms
     CGroup: /system.slice/firewalld.service
             └─3317 /usr/bin/python3 /usr/sbin/firewalld --nofork --nopid

Nov 01 21:11:00 systemd[1]: Starting firewalld - dynamic firewall daemon...
Nov 01 21:11:00 systemd[1]: Started firewalld - dynamic firewall daemon.
```

If you have ufw enabled, **disable it to make firewalld your default firewall**

```shell
sudo ufw disable
```
## Using Firewalld on Debian 10

### List all rules configured in firewall

```shell
$ sudo firewall-cmd --list-all

public (active)
target: default
icmp-block-inversion: no
interfaces: ens01
sources:
services: dhcpv6-client ssh
ports:
protocols:
masquerade: no
forward-ports:
source-ports:
icmp-blocks:
rich rules:
 
```

`ssh` and `dhcpv6-client` services are allowed by default.

### List services that can be enabled/disabled

To get a full list of services which can be enabled or disabled, use a command.

```shell
sudo firewall-cmd --get-services
```

### Reload firewalld

To reload firewalld, you can use the command line client firewall-cmd:

```shell
firewall-cmd --reload
```

Reload firewall rules and keep state information. Current permanent configuration will become new runtime configuration, 
i.e. all runtime only changes done until reload are lost with reload if they have not been also put into the permanent configuration.

```shell
firewall-cmd --complete-reload
```

Reload firewall completely, even netfilter kernel modules. This will most likely terminate active connections, 
because state information is lost. This option should only be used in case of severe firewall problems. 
For example, if there are state information problems that no connection can be established with correct firewall rules.

### Enable and Disable firewalld

It is not recommended to use iptables directly while firewalld is running as this could lead into some unexpected issues. 
If a user, for example, is removing base rules or chains of the chain structure, then a firewalld reload might be needed 
to create them again.

#### Install and enable firewalld

If the iptables, ip6tables, ebtables and ipset services are in use:

```shell
systemctl disable --now iptables.service
systemctl disable --now ip6tables.service
systemctl disable --now etables.service
systemctl disable --now ipset.service
dnf install firewalld firewall-config firewall-applet
systemctl unmask --now firewalld.service
systemctl enable --now firewalld.service
```

To check the firewall state you have different options. 
The fist option is to use 

```shell
systemctl status firewalld
``` 

the other one is to use 

```shell
firewall-cmd --state
```

The output of the systemctl command should look like this:

```shell
$ systemctl status firewalld

● firewalld.service - firewalld - dynamic firewall daemon
Loaded: loaded (/usr/lib/systemd/system/firewalld.service; enabled; vendor pr
Active: active (running) since Wed 2016-06-29 14:28:51 CEST; 1 weeks 6 days a
Docs: man:firewalld(1)
Main PID: 24540 (firewalld)
Tasks: 2 (limit: 512)
CGroup: /system.slice/firewalld.service
└─24540 /usr/bin/python3 -Es /usr/sbin/firewalld --nofork --nopid
```

The output of the firewall-cmd command should look like this:

```shell
$ firewall-cmd --state
running
```

#### Install and enable iptables, ip6tables, ebtables and ipset services

If firewalld is enabled and you want to enable the iptables, ip6tables, ebtables and ipset services instead:

```shell
dnf install iptables-services ebtables ipset-service
systemctl mask --now firewalld.service
systemctl enable --now iptables.service
systemctl enable --now ip6tables.service
systemctl enable --now etables.service
systemctl enable --now ipset.service
```

The use of the mask line is recommended as systemd will start firewalld if there is another service requires it or if the 
D-Bus interface of firewalld is used. If the service only gets disabled, then it will not be auto started anymore.

### Enable service or list of services

To allow a service on the firewall, use a command:

```shell
sudo firewall-cmd --add-service="servicename" --permanent
```

The example below will enable **https** service.

```shell
$ sudo firewall-cmd --add-service="https" --permanent
success

$ sudo firewall-cmd --reload
```

To get a list of services, you can separate services with comma.

```shell
sudo firewall-cmd --add-service={http,https,smtp,imap,nfs} --permanent --zone=public

sudo firewall-cmd --reload
```

### Enable TCP port

The syntax for enabling a TCP port is:

```shell
sudo firewall-cmd --add-port=port/tcp --permanent

sudo firewall-cmd --reload
```

E.g. we want to enable port 5050 and 3030.

```shell
sudo firewall-cmd --zone=public --add-port=5050/tcp --permanent
sudo firewall-cmd --zone=public --add-port={5050,3030}/tcp --permanent

sudo firewall-cmd --reload
```

For UDP ports, use /udp instead /tcp.

### Create a new zone

To create a new firewall zone, use the command:

```shell
$ sudo firewall-cmd --new-zone=zonename --permanent
```

F.e.

```shell
$ sudo firewall-cmd --new-zone=private --permanent

$ sudo firewall-cmd --reload
```

#### Enable service/port on a specific zone

To enable a service or/and port in a specific zone, use a syntax:

```shell
sudo firewall-cmd --zone=<zone> --add-port=<port>/tcp --permanent
sudo firewall-cmd --zone=<zone> --add-port=<port>/udp --permanent
sudo firewall-cmd --zone=<zone> --add-service=<servicename> --permanent
sudo firewall-cmd --zone=<zone> --add-service={servicename1,servicename2,servicename3,servicename4} --permanent
```

### Add an interface to a zone

For systems with more than one interface, you may add an interface to a zone. 
E.g., our backend system service to private zone, and fronted user service to public zone.

```shell
sudo firewall-cmd --get-zone-of-interface=eon1 --permanent
sudo firewall-cmd --zone=<zone> --add-interface=eon1 --permanent
```

### Allow access to a port from specific subnet/IP

Access to a service or any port can be restricted, and to be from specific IP address or subnet accept. 
You can to do it with the use of rules.

```shell
$ sudo firewall-cmd --add-rich-rule 'rule family="ipv4" service name="https" source address="192.168.5.12/32" accept' --permanent
$ sudo firewall-cmd --add-rich-rule 'rule family="ipv4" service name="https" source address="172.16.1.0/24" accept' --permanent
```

### List rich rules

Use the following command:

```shell
sudo firewall-cmd --list-rich-rules
```

### Port forwarding

##### Enable masquerading

```shell
sudo firewall-cmd --add-masquerade --permanent
```
##### Port forward to a different port within same server ( 21 > 2021)
```shell
sudo firewall-cmd --add-forward-port=port=21:proto=tcp:toport=2021 --permanent
```

##### Port forward to same port on a different server (local:21 > 192.168.12.10:21)
```shell
sudo firewall-cmd --add-forward-port=port=21:proto=tcp:toaddr=192.168.12.10 --permanent
```

##### Port forward to different port on a different server (local:5555 > 172.128.3.4:55555)

```shell
sudo firewall-cmd --add-forward-port=port=5555:proto=tcp:toport=55555:toaddr=172.128.3.4 --permanent
```

### Removing a port or a service

To remove a port or service from the firewall: replace `--add` with `–-remove` in each command used in enabling service.

### Firewall documentation

[https://firewalld.org/documentation/](https://firewalld.org/documentation/)


