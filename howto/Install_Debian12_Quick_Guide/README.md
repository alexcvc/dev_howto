Install and build your Debian 12 system as your workbench
===

## Installation from USB (netinst)

**Important in case of LSA MegaRAID SAS 9440-8i**

  All partitions that will be used in the future must be mounted to target directories during the installation.
  Otherwise, if you mount RAID discs later, Debian 12 may hang on the RAID discs.

## To enable sudo on a user account on Debian

1. First, open up your terminal and get the root access:

```
su root
```

2. Now install sudo :

```
apt-get install sudo
```

3. Then, add the user account in which you need to use the sudo privileges:

```
adduser username sudo
echo "username ALL=(ALL) PASSWD: ALL" > /etc/sudoers.d/username_sudoers
```

4. Change the default sudo password timeout (and make it either longer or shorter), add the following line at the end of the file and change its value to whatever time (in minutes) you want it to wait for before the timeout.
 
```
Defaults          timestamp_timeout=x
Defaults:username timestamp_timeout=x
```

4. Logout from the root user session:

```
exit
```

5. Now your user account must have the sudo access. Feel free to try it:

```
sudo ls
```

## Install general tools

```
sudo apt-get install vim mc htop atop git tig tilix 
```

## Set permission for workbench folders

```
sudo chmod 777 /opt/ /srv/
cd /home
sudo cd /home
sudo mkdir backup/ codebase/ deploy/ doc/ files/ main/ work/
sudo chmod 777 backup/ codebase/ deploy/ doc/ files/ main/ work/
sudo mkdir /home/tmp ; sudo chmod 777 /home/tmp 
```

## Install and Setup TFTPD Server

I am going to install and configure tftpd-hpa.

TFTP server/protocol provides little security. Make sure a TFTP server is placed behind a firewall system. 

### tftpd-hpa TFTP server installation

Type the following apt-get command as root user:

```
sudo apt-get install tftpd-hpa
```

You will be promoted as follows (make sure you set the directory name to /srv/tftp):

```
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
Suggested packages:
  pxelinux
The following NEW packages will be installed:
  tftpd-hpa
0 upgraded, 1 newly installed, 0 to remove and 0 not upgraded.
Need to get 41.9 kB of archives.
After this operation, 117 kB of additional disk space will be used.
Get:1 http://deb.debian.org/debian bookworm/main amd64 tftpd-hpa amd64 5.2+20150808-1.4 [41.9 kB]
Fetched 41.9 kB in 0s (653 kB/s)
Preconfiguring packages ...
Selecting previously unselected package tftpd-hpa.
(Reading database ... 357509 files and directories currently installed.)
Preparing to unpack .../tftpd-hpa_5.2+20150808-1.4_amd64.deb ...
Unpacking tftpd-hpa (5.2+20150808-1.4) ...
Setting up tftpd-hpa (5.2+20150808-1.4) ...

tftpd-hpa directory (/srv/tftp) already exists, doing nothing.
Processing triggers for man-db (2.11.2-2) ...
```

### Configuration

Edit /etc/default/tftpd-hpa, run:

```
sudo vim /etc/default/tftpd-hpa
```

Sample configuration:

```
TFTP_USERNAME="tftp"
TFTP_DIRECTORY="/srv/tftp"
TFTP_ADDRESS="0.0.0.0:69"
TFTP_OPTIONS="--secure"
```

How do I start / stop / restart tftpd-hpa server?

Type the following commands:

```
sudo systemctl status tftpd-hpa.service 

● tftpd-hpa.service - LSB: HPA's tftp server
     Loaded: loaded (/etc/init.d/tftpd-hpa; generated)
     Active: active (running) since Sun 2023-09-10 07:51:47 CEST; 2min 52s ago
       Docs: man:systemd-sysv-generator(8)
    Process: 64976 ExecStart=/etc/init.d/tftpd-hpa start (code=exited, status=0/SUCCESS)
      Tasks: 1 (limit: 37702)
     Memory: 1.0M
        CPU: 27ms
     CGroup: /system.slice/tftpd-hpa.service
             └─64984 /usr/sbin/in.tftpd --listen --user tftp --address :69 --secure /srv/tftp

Sep 10 07:51:47 DEBIAN5820 systemd[1]: Starting tftpd-hpa.service - LSB: HPA's tftp server...
Sep 10 07:51:47 DEBIAN5820 tftpd-hpa[64976]: Starting HPA's tftpd: in.tftpd.
Sep 10 07:51:47 DEBIAN5820 systemd[1]: Started tftpd-hpa.service - LSB: HPA's tftp server.
```


