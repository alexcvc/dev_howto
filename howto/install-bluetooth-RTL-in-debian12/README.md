# Bluetooth RTL: firmware file rtl_bt/rtl8761bu_fw.bin not found

## Avantree DG45 Bluetooth USB Adapter

System: Kernel 6.x x86_64 bits: 64 
Linux Debian 12 

```shell
sudo dmesg | grep -i Bluetooth
[    1.721262] usb 1-7: Product: Bluetooth Radio
[    5.849701] Bluetooth: Core ver 2.22
[    5.849711] NET: Registered PF_BLUETOOTH protocol family
[    5.849711] Bluetooth: HCI device and connection manager initialized
[    5.849713] Bluetooth: HCI socket layer initialized
[    5.849715] Bluetooth: L2CAP socket layer initialized
[    5.849716] Bluetooth: SCO socket layer initialized
[    5.863314] Bluetooth: hci0: RTL: examining hci_ver=0a hci_rev=000b lmp_ver=0a lmp_subver=8761
[    5.864314] Bluetooth: hci0: RTL: rom_version status=0 version=1
[    5.864316] Bluetooth: hci0: RTL: loading rtl_bt/rtl8761bu_fw.bin
[    5.897790] bluetooth hci0: Direct firmware load for rtl_bt/rtl8761bu_fw.bin failed with error -2
[    5.897795] Bluetooth: hci0: RTL: firmware file rtl_bt/rtl8761bu_fw.bin not found
[    7.074927] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    7.074930] Bluetooth: BNEP filters: protocol multicast
[    7.074934] Bluetooth: BNEP socket layer initialized
[   82.525863] usb 1-7: Product: Bluetooth Radio
[   82.529581] Bluetooth: hci0: RTL: examining hci_ver=0a hci_rev=000b lmp_ver=0a lmp_subver=8761
[   82.531484] Bluetooth: hci0: RTL: rom_version status=0 version=1
[   82.531496] Bluetooth: hci0: RTL: loading rtl_bt/rtl8761bu_fw.bin
[   82.531548] bluetooth hci0: Direct firmware load for rtl_bt/rtl8761bu_fw.bin failed with error -2
[   82.531556] Bluetooth: hci0: RTL: firmware file rtl_bt/rtl8761bu_fw.bin not found
[   89.942182] usb 1-7: Product: Bluetooth Radio
[   89.945415] Bluetooth: hci0: RTL: examining hci_ver=0a hci_rev=000b lmp_ver=0a lmp_subver=8761
[   89.946379] Bluetooth: hci0: RTL: rom_version status=0 version=1
[   89.946390] Bluetooth: hci0: RTL: loading rtl_bt/rtl8761bu_fw.bin
[   89.946445] bluetooth hci0: Direct firmware load for rtl_bt/rtl8761bu_fw.bin failed with error -2
[   89.946454] Bluetooth: hci0: RTL: firmware file rtl_bt/rtl8761bu_fw.bin not found

```

## Solution

1. Download it from a GitHub repository to ~/Downloads/Realtek. For Realtek devices it would be 

https://github.com/Realtek-OpenSource/android_hardware_realtek/tree/rtk1395/bt/rtkbt/Firmware/BT

[RTL.bluetooth.tar.gz](https://github.com/alexcvc/howto_embedded/files/13928162/RTL.bluetooth.tar.gz)

2. Simply create a soft links this:

```shell

$ sudo mkdir /usr/lib/firmware/rtl_bt
$ cd /usr/lib/firmware/rtl_bt
$ sudo cp ~/Downloads/Realtek/rtl8761b_fw .
$ sudo cp ~/Downloads/Realtek/rtl8761b_config .
$ sudo ln -s rtl8761b_fw rtl8761bu_fw.bin
$ sudo ln -s rtl8761b_config rtl8761bu_config.bin
$ ll /usr/lib/firmware/rtl_bt

total 32K
-rwxr-xr-x 1 root root  14 Jan 10 20:53 rtl8761b_config*
-rwxr-xr-x 1 root root 26K Jan 10 20:54 rtl8761b_fw*
lrwxrwxrwx 1 root root  15 Jan 10 20:58 rtl8761bu_config.bin -> rtl8761b_config*
lrwxrwxrwx 1 root root  11 Jan 10 20:55 rtl8761bu_fw.bin -> rtl8761b_fw*
```

After connect USB Bluetooth check the log messages

```shell
 $ sudo dmesg | grep Bluetooth
[29560.283060] Bluetooth: hci0: RTL: examining hci_ver=0a hci_rev=000b lmp_ver=0a lmp_subver=8761
[29560.284047] Bluetooth: hci0: RTL: rom_version status=0 version=1
[29560.284057] Bluetooth: hci0: RTL: loading rtl_bt/rtl8761bu_fw.bin
[29560.284154] bluetooth hci0: firmware: direct-loading firmware rtl_bt/rtl8761bu_fw.bin
[29560.284191] Bluetooth: hci0: RTL: loading rtl_bt/rtl8761bu_config.bin
[29560.284235] bluetooth hci0: firmware: direct-loading firmware rtl_bt/rtl8761bu_config.bin
[29560.284261] Bluetooth: hci0: RTL: cfg_sz 14, total sz 11678
[29560.359040] Bluetooth: hci0: RTL: fw version 0x097bec43
[29560.424379] Bluetooth: MGMT ver 1.22

```

Then restart a computer.

Enjoy!
