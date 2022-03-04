# How to install debian 11


  https://trendoceans.com/how-to-install-cmake-on-debian-10-11/

  https://www.how2shout.com/linux/install-docker-ce-on-debian-11-bullseye-linux/
  
  https://markontech.com/linux/setup-nfs-server-on-debian/  

  https://www.how2shout.com/linux/install-ifconfigon-debian-11-or-10-if-command-not-found/
  
  https://trendoceans.com/how-to-install-cmake-on-debian-10-11/
  
  https://www.troublenow.org/752/debian-10-add-rc-local/
  
  ### Setup TFTP in debian 11
  
  https://www.cyberciti.biz/faq/install-configure-tftp-server-ubuntu-debian-howto/
  
  #### Configuration
  
Edit /etc/default/tftpd-hpa, run:

    vi /etc/default/tftpd-hpa

Sample configuration with root!:

    TFTP_USERNAME="root"
    TFTP_DIRECTORY="/srv/tftp"
    TFTP_ADDRESS="0.0.0.0:69"
    TFTP_OPTIONS="--secure"

### How can I make the nfs server support protocol version 2 in Debian 11?

You need to modify /etc/default/nfs-kernel-server to have these lines:

```
RPCNFSDOPTS="--nfs-version 2,3,4 --debug --syslog"
# To confirm above mods are in effect after service restart use
#     cat /run/sysconfig/nfs-utils
#  or 
#    service nfs-kernel-server status
#
```

and restart the service

`service nfs-kernel-server restart`

take care that after service restart you may need to re-start shares
Finally confirm that protocol 2 is being supported (tcp and udp too if necessary)

```
rpcinfo -p servername | fgrep nfs
```

You should see this

```
100003    2   tcp   2049  nfs
100003    3   tcp   2049  nfs
100003    4   tcp   2049  nfs
100003    2   udp   2049  nfs
100003    3   udp   2049  nfs
```
