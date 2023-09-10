# Installation from USB (netinst)

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
```

echo "username ALL=(ALL) PASSWD: ALL" > /etc/sudoers.d/username_sudoers

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
sudo chmod 777 backup/ codebase/ deploy/ doc/ files/ main/ wsudo work/
sudo mkdir /home/tmp ; sudo chmod 777 /home/tmp 
```



