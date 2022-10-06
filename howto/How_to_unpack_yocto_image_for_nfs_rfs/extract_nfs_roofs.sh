#!/bin/bash

IMAGE_NAME=teledata-image-dev-teledata-tk28
NFSROOT_NAME=tk28-nfsroot
MOUNTDIR=./mnt_$$
NFSROOTDIR=./nfsroot_$$

    echo "To log on with the user root and the password root, you need to edit the file /etc/passwd."
    echo "Rewrite first line in file as follow"
    # root:$1$76ESofJQ$hFFvKy.WBBNe811x48cUO.:0:0:root,,,:/home/root:/bin/sh
    echo "root:\$1\$76ESofJQ\$hFFvKy.WBBNe811x48cUO.:0:0:root,,,:/home/root:/bin/sh"
    read -p "Press Enter to exit.."

if [ -f ${NFSROOT_NAME}.tar.gz ] ; then
    echo "File ${NFSROOT_NAME}.tar.gz already exist and may be overwritten!"
    exit 0
fi

echo ""
echo "=========================================="
echo " Excluding image"
echo "=========================================="
echo ""

if [ -f ${IMAGE_NAME}.wic.gz ] ; then
    gunzip ${IMAGE_NAME}.wic.gz
fi

if [ ! -f ${IMAGE_NAME}.wic ] ; then
    echo "File ${IMAGE_NAME}.wic diesn't exist.."
    exit 1
fi

sudo losetup -fP --show ${IMAGE_NAME}.wic

echo ""
echo "=========================================="
echo " Mount and copy to NFS image"
echo "=========================================="
echo ""

read -p "Enter number of the loopdevice /dev/loop..: " LOOPDEVICENUMB;

if [ -n ${LOOPDEVICENUMB} ] ; then
    
    if test -d "$MOUNTDIR"; then
        echo "remove ${MOUNTDIR}"
        sudo rm -r ${MOUNTDIR}
    fi
    
    if test -d "$NFSROOTDIR"; then
        echo "remove ${NFSROOTDIR}"
        sudo rm -r ${NFSROOTDIR}
    fi
    
    mkdir ${MOUNTDIR}
    mkdir ${NFSROOTDIR}
    
    sudo mount /dev/loop${LOOPDEVICENUMB}p3 ${MOUNTDIR}
    sudo cp -a ${MOUNTDIR}/.  ${NFSROOTDIR}
    sudo umount ${MOUNTDIR}
    
    sudo mount /dev/loop${LOOPDEVICENUMB}p2 ${MOUNTDIR}
    sudo cp ${MOUNTDIR}/*  ${NFSROOTDIR}/boot/
    sudo umount ${MOUNTDIR}
    
    sudo rm -r ${MOUNTDIR}
    
    sudo tar czf ${NFSROOT_NAME}.tar.gz ${NFSROOTDIR}

    echo "To log on with the user root and the password root, you need to edit the file /etc/passwd."
    echo "Rewrite first line in file as follow"
    # root:$1$76ESofJQ$hFFvKy.WBBNe811x48cUO.:0:0:root,,,:/home/root:/bin/sh
    echo "root:\$1\$76ESofJQ\$hFFvKy.WBBNe811x48cUO.:0:0:root,,,:/home/root:/bin/sh"
    read -p "Press Enter to exit.."

fi

sudo losetup -D

if test -d "$MOUNTDIR"; then
    echo "remove ${MOUNTDIR}"
    sudo rm -r ${MOUNTDIR}
fi

if test -d "$NFSROOTDIR"; then
    echo "remove ${NFSROOTDIR}"
    sudo rm -r ${NFSROOTDIR}
fi

exit 0
