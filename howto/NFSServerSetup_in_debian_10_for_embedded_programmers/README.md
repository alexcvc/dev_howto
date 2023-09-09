# NFS Server Setup (all v2,3,4)

Make sure you have NFS server support in your server's kernel 
(kernel module named "knfsd.ko" under your /lib/modules/uname -r/ directory structure)

    $ grep NFSD /boot/config-`uname -r`

or similar (wherever you've stashed your config file, for example, perhaps in /usr/src/linux/.config.)

Then, note that there are at least two mainstream NFS server implementations at present (excluding those implemented in Python and similar): 
one implemented in user space (slower, easier to debug), and the other implemented in kernel space (faster.) 
The below shows the setup of the kernel-space one. If you wish to use the user-space server, then install the similarly-named package.

##  First, the packages to begin with:

    $ apt install nfs-kernel-server portmap

NOTE: The portmap package ++is only required++ if you want to run an NFSv2 or NFSv3 server.  
If all your clients support NFSv4, you can disable NFSv2 and NFSv3 (as described in the "NFSv4 only" section below) and skip the "Portmap" section below.

##  Portmap

Note that portmap defaults to only listening for NFS connection attempts on 127.0.0.1 (localhost), so if you wish to allow connections on your local network, then you need to edit /etc/default/portmap, to comment out the "OPTIONS" line. Also, we need to ensure that the /etc/hosts.allow file allows connections to the portmap port. For example:

    $ perl -pi -e 's/^OPTIONS/#OPTIONS/' /etc/default/portmap
    $ echo "portmap: 192.168.1." >> /etc/hosts.allow
    $ echo "portmap: 172.16." >> /etc/hosts.allow
    $ /etc/init.d/portmap restart

See 'man hosts.allow' for examples on the syntax. But in general, specifying only part of the IP address like this (leaving the trailing period) treats the specified IP address fragment as a wildcard, allowing all IP addresses in the range 192.168.1.0 to 192.168.1.255 (in this example.) You can do more "wildcarding" using DNS names, and so on too. Note, 'portmap' is provided by the 'rpcbind' deb package (at least on Stretch).

## Exports

Edit the /etc/exports file, which lists the server's filesystems to export over NFS to client machines. And create the NFS table with "exportfs -a". The following example shows the addition of a line which adds the path "/example", for access by any machine on the local network (here 192.168.1.*).

    # /etc/exports: the access control list for filesystems which may be exported
    #               to NFS clients.  See exports(5).
    #
    # Example for NFSv2 and NFSv3:
    # /srv/homes       hostname1(rw,sync,no_subtree_check) hostname2(ro,sync,no_subtree_check)
    #
    # Example for NFSv4:
    # /srv/nfs4        gss/krb5i(rw,sync,fsid=0,crossmnt,no_subtree_check)
    # /srv/nfs4/homes  gss/krb5i(rw,sync,no_subtree_check)
    #
    
    /srv/tftp                172.16.0.0/16(rw,no_root_squash,subtree_check) 172.15.0.0/16(rw,no_root_squash,subtree_check) 172.17.0.0/16(rw,no_root_squash,subtree_check) 172.18.0.0/16(rw,no_root_squash,subtree_check) 192.168.1.0/24(rw,no_root_squash,subtree_check)
    /srv/nfs                 172.16.0.0/16(rw,no_root_squash,subtree_check) 172.15.0.0/16(rw,no_root_squash,subtree_check) 172.17.0.0/16(rw,no_root_squash,subtree_check) 172.18.0.0/16(rw,no_root_squash,subtree_check) 192.168.1.0/24(rw,no_root_squash,subtree_check)
    /opt                     172.16.0.0/16(rw,sync,no_subtree_check) 172.15.0.0/16(rw,sync,no_subtree_check) 172.17.0.0/16(rw,sync,no_subtree_check) 172.18.0.0/16(rw,sync,no_subtree_check) 192.168.1.0/24(rw,sync,no_subtree_check)
    /home                    172.16.0.0/16(rw,sync,no_subtree_check) 172.15.0.0/16(rw,sync,no_subtree_check) 172.17.0.0/16(rw,sync,no_subtree_check) 172.18.0.0/16(rw,sync,no_subtree_check) 192.168.1.0/24(rw,sync,no_subtree_check)

Then new export shared folders:

    $ exportfs -a
    $ /etc/init.d/nfs-kernel-server reload

This tells the server to serve up that path, readable/writable, with root-user-id connecting clients to use root access instead of being mapped to 'nobody', and to use the 'subtree_check' to silence a warning message. Then, reloads the server.

Note: If you want /etc/exports to share an NFS share to multiple, discrete entries, use space-separate entries. The syntax looks like this:

    $ echo "/multi-example    192.168.1.0/24(rw) 172.16.1.0/24(ro)  10.11.12.0/24(rw)" >> /etc/exports

Check which versions of NFS the server is running this way:

    root@deb9:/# cat /proc/fs/nfsd/versions
    -2 -3 +4 +4.1 +4.2

In this case, nfs2, nfs3 are disabled. NFS 4, 4.1, and 4.2 are enabled.  Any client trying to connect with NFSv2 or NFSv3 should get an error.
From the client side (for example, I used a PLD "rescue" disk to boot up a Windows machine for some diagnostics, and used its built-in NFS client support to mount a path from my other computer), you need to ensure that portmap is running, and that the NFS client support is built into the kernel or the proper module ("nfs.ko") is loaded, and then mount the server's path like so:

    $ mount 192.168.1.100:/example /mnt/example

To help debug:

try running 'rpcinfo -p' from the server (and from clients 'rpcinfo -p <server>'), as you should see a largish list of information, including 'nfs' and 'portmapper' as some of the lines. If you get messages about not being able to connect, then you may have firewall rules blocking access to portmap. See this related NFS-HOWTO section for further details on decyphering the output of 'rpcinfo.'

You could also 'cat /proc/fs/nfs/exports' to see the list of filesystems exported by the NFS file server.
NFSv4 only
To enable only NFSv4 or higher (and thus disabling v2 and v3), set the following variables in /etc/default/nfs-common:

    NEED_STATD="no"
    NEED_IDMAPD="yes"

And the following in /etc/default/nfs-kernel-server. Please note that RPCNFSDOPTS is not present by default, and needs to be added.

    RPCNFSDOPTS="-N 2 -N 3"
    RPCMOUNTDOPTS="--manage-gids -N 2 -N 3"

Additionally, rpcbind is not needed by NFSv4 but will be started as a prerequisite by nfs-server.service. This can be prevented by masking rpcbind.service and rpcbind.socket:

    sudo systemctl mask rpcbind.service
    sudo systemctl mask rpcbind.socket

NFSv4 only requires a single port (TCP/UDP 2049) and does not require the portmap service to be installed.

## Listening only on particular IPsBy default, NFS will listen for connections on all ports.

To only listen for NFS(v4) connections on a particular IP address, add the -H option to RPCNFSDOPTS in /etc/default/nfs-kernel-server:

    RPCNFSDOPTS="-N 2 -N 3 -H 10.0.1.1"

Alternatively, a hostname may be provided instead of an IP address. The -H option can also be provided multiple times to listen on multiple different IPs.

## How to make the nfs server support protocol version 2

You need to modify /etc/default/nfs-kernel-server to have these lines:

    RPCNFSDOPTS="--nfs-version 2,3,4 --debug --syslog"
    
    # To confirm above mods are in effect after service restart use
    #     cat /run/sysconfig/nfs-utils
    #  or 
    #    service nfs-kernel-server status
    #

and restart the service

    service nfs-kernel-server restart

Finally confirm that protocol 2 is being supported (tcp and udp too if necessary)

    rpcinfo -p localhost | fgrep nfs

You should see this

    100003    2   tcp   2049  nfs
    100003    3   tcp   2049  nfs
    100003    4   tcp   2049  nfs
    100003    2   udp   2049  nfs
    100003    3   udp   2049  nfs

# Examples for Debian 11

File `/etc/exports`:

```
# /etc/exports: the access control list for filesystems which may be exported
#               to NFS clients.  See exports(5).
#
# Example for NFSv2 and NFSv3:
# /srv/homes       hostname1(rw,sync,no_subtree_check) hostname2(ro,sync,no_subtree_check)
#
# Example for NFSv4:
# /srv/nfs4        gss/krb5i(rw,sync,fsid=0,crossmnt,no_subtree_check)
# /srv/nfs4/homes  gss/krb5i(rw,sync,no_subtree_check)
#

/srv                     *(rw,no_root_squash,subtree_check)
/srv/tftp                192.168.1.0/255.255.255.0(rw,no_root_squash,subtree_check)
/srv/nfs                 192.168.1.0/255.255.255.0(rw,no_root_squash,subtree_check)
```

File `/etc/default/nfs-common` :

```
# If you do not set values for the NEED_ options, they will be attempted
# autodetected; this should be sufficient for most people. Valid alternatives
# for the NEED_ options are "yes" and "no".

# Do you want to start the statd daemon? It is not needed for NFSv4.
NEED_STATD=

# Options for rpc.statd.
#   Should rpc.statd listen on a specific port? This is especially useful
#   when you have a port-based firewall. To use a fixed port, set this
#   this variable to a statd argument like: "--port 4000 --outgoing-port 4001".
#   For more information, see rpc.statd(8) or http://wiki.debian.org/SecuringNFS
STATDOPTS=

# Do you want to start the idmapd daemon? It is only needed for NFSv4.
NEED_IDMAPD=

# Do you want to start the gssd daemon? It is required for Kerberos mounts.
NEED_GSSD=

```



File `/etc/default/nfs-kernel-server` :

```
# Number of servers to start up
# enable NFSv2
RPCNFSDCOUNT="8 --nfs-version 2"

# Runtime priority of server (see nice(1))
RPCNFSDPRIORITY=0

# Options for rpc.mountd.
# If you have a port-based firewall, you might want to set up
# a fixed port here using the --port option. For more information, 
# see rpc.mountd(8) or http://wiki.debian.org/SecuringNFS
# To disable NFSv4 on the server, specify '--no-nfs-version 4' here
RPCMOUNTDOPTS="--no-nfs-version 4 --manage-gids"

# Do you want to start the svcgssd daemon? It is only required for Kerberos
# exports. Valid alternatives are "yes" and "no"; the default is "no".
NEED_SVCGSSD=""

# Options for rpc.svcgssd.
RPCSVCGSSDOPTS=""

```

# Kernel 6

From Ubuntu 22.04, the hack of RPCNFSDCOUNT/RPCNFSDOPTS doesn't work any more (because /lib/systemd/scripts/nfs-utils_env.sh has been removed, which used the RPCNFSDCOUNT/RPCNFSDOPTS variables).

Do this instead:

```shell
echo -e "[nfsd]\nudp=y\nvers2=y" | sudo tee /etc/nfs.conf.d/local.conf
sudo systemctl restart nfs-server.service
```

How did I found out this configuration:

```shell
    systemctl cat nfs-server.service shows nfs-server.service executes rpc.nfsd (ExecStart=/usr/sbin/rpc.nfsd)
    man rpc.nfsd shows the configuration file is located at /etc/nfs.conf
    man nfs.conf shows the format of the configuration file, and says /etc/nfs.conf.d/*.conf is also valid configuration files
```

You can confirm that the configuration is applied with these commands:

```shell
    nfsconf --dump
    rpcinfo -s
    rpcinfo -p
    sudo cat /proc/fs/nfsd/versions
```
