#!/bin/bash

# Script for setup firewalld
## Mainly used in development
# dhcp,dhcpv6,dhcpv6-client,nfs,nfs3,ntp,dns,samba,samba-client,samba-dc
# ssh,svn,syslog,syslog-tls,telnet,tftp,tftp-client,ftp,git,high-availability,http,https
# ipp,ipp-client,ipsec,irc,ircs,iscsi-target,isns,jenkins
# smtp,smtp-submission,smtps,snmp,snmptrap,squid
# docker-registry,docker-swarm,mqtt,mqtt-tls,mssql,proxy-dhcp,ptp
# radius,redis,rpc-bind,rsh,rsyncd,rtsp,finger,mountd
# nut,openvpn,kerberos,libvirt,libvirt-tls,lightning-network,mdns
# transmission-client,pop3,pop3s,imap,imaps,pulseaudio,mongodb,postgresql

# public
sudo firewall-cmd --add-service={dhcp,dhcpv6,proxy-dhcp} --permanent --zone=public
sudo firewall-cmd --add-service={ssh,syslog,syslog-tls,telnet,tftp,tftp-client,ftp,http,https} --permanent --zone=public
sudo firewall-cmd --add-service={nfs,nfs3,samba,svn,git,high-availability} --permanent --zone=public
sudo firewall-cmd --add-service={ntp,dns} --permanent --zone=public
sudo firewall-cmd --add-service={radius,rpc-bind,rsh,rsyncd,finger,mountd} --permanent --zone=public
sudo firewall-cmd --add-service={nut,openvpn,kerberos,libvirt,libvirt-tls} --permanent --zone=public
sudo firewall-cmd --add-service={ipp,ipsec,irc,ircs} --permanent --zone=public
sudo firewall-cmd --add-service={smtp,smtp-submission,smtps,snmp,snmptrap} --permanent --zone=public
sudo firewall-cmd --add-service={docker-registry,docker-swarm,mqtt,mqtt-tls,ptp} --permanent --zone=public
sudo firewall-cmd --add-service={transmission-client,pop3,pop3s,imap,imaps,pulseaudio} --permanent --zone=public
sudo firewall-cmd --add-service={mssql,mongodb,postgresql} --permanent --zone=public

sudo firewall-cmd --zone=public --add-port={102,55005}/tcp --permanent
sudo firewall-cmd --zone=public --add-port={102,55005}/tcp --permanent

$ sudo firewall-cmd --add-rich-rule 'rule family="ipv4" service name="nfs,samba,tftp,ftp,sshtelnet,https,http" source address="192.168.1.0/24" accept' --permanent
$ sudo firewall-cmd --add-rich-rule 'rule family="ipv4" service name="nfs,samba,tftp,ftp,sshtelnet,https,http" source address="172.15.0.0/16" accept' --permanent
$ sudo firewall-cmd --add-rich-rule 'rule family="ipv4" service name="nfs,samba,tftp,ftp,sshtelnet,https,http" source address="172.16.0.0/16" accept' --permanent
$ sudo firewall-cmd --add-rich-rule 'rule family="ipv4" service name="nfs,samba,tftp,ftp,sshtelnet,https,http" source address="172.17.0.0/16" accept' --permanent
$ sudo firewall-cmd --add-rich-rule 'rule family="ipv4" service name="nfs,samba,tftp,ftp,sshtelnet,https,http" source address="172.18.0.0/16" accept' --permanent
$ sudo firewall-cmd --add-rich-rule 'rule family="ipv4" service name="nfs,samba,tftp,ftp,sshtelnet,https,http" source address="172.19.0.0/16" accept' --permanent

