How to fetch root file system for Net-booting from yocto image
===

Unpack the image file wic.gz as follows:

````
user@pc $ gunzip <name_of_image_file>.wic.gz
user@pc $ sudo losetup -fP --show <name_of_image_file>.wic
/dev/loop3
user@pc $ sudo mount /dev/loop3p3 /mnt/
user@pc $ sudo cp -a /mnt/. <nfs-root>
user@pc $ sudo umount /mnt
user@pc $ sudo mount /dev/loop3p2 /mnt/
user@pc $ sudo cp /mnt/* <nfs-root>/boot/
user@pc $ sudo umount /mnt
```

### BBB raw image: change root password

It is useful to change the password for the root user.
Use `sudo vim ./etc/passwd` and change the first line in the file

```
root:$1$76ESofJQ$hFFvKy.WBBNe811x48cUO.:0:0:root,,,:/home/root:/bin/sh
```
Then you are able to login  with user root in console with password `root`

A.S
