# Problem initialising more than 4 serial ports

Using a extended board which has 2-8 serial devices, the kernel improperly initialises the serial hardware,
I can tell, none of the ports work properly with the default configuration.

## The resolution

The resolution turns out to be pretty simple (at least for this board, most likely others too). 
Simply set the number of ports to initialise to be enough for all the hardware: for this board, set 8250.nr_uarts=8 on the boot command line. 
After which the kernels sets up the ports exactly as expected and furthermore, they work as expected also.

For those that don't regularly change the grub configuration, the mechanics are:

Edit `/etc/default/grub` and add `8250.nr_uarts=8` to the line starting GRUB_CMDLINE_LINUX=... 
Run 

```
grub2-mkconfig -o /boot/grub2/grub.cfg
reboot
```
## Post

January 26th, 2012, 06:39 AM
Digging up an older thread, but this was a top result on Google for this problem.

What's happening is that the Debian kernel is compiled by default with only 4 serial ports enabled. 
See http://www.debian-administration.org/users/lauri/weblog/1 
The hard way to fix this would be to recompile, changing the config parameters:

```
CONFIG_SERIAL_8250_NR_UARTS=32
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
```

Recompiling would let you set the parameters in the kernel itself (and maybe have more than 32 serial ports?).

The easy way to fix this is (as root) to edit /etc/default/grub and append " 8250.nr_uarts=8" (without quotes) to the end of the line "GRUB_CMDLINE_LINUX_DEFAULT=". It might then look like :

GRUB_CMDLINE_LINUX_DEFAULT="quiet 8250.nr_uarts=8"
You can set any number up to 32 as the number of serial ports this way.

You then have to run "update-grub" as root. After rebooting you should have the serial ports working.


---------------------------

Digging up an older thread, but this was a top result on Google for this problem.

What's happening is that the Debian kernel is compiled by default with only 4 serial ports enabled. See http://www.debian-administration.org/users/lauri/weblog/1 The hard way to fix this would be to recompile, changing the config parameters:

CONFIG_SERIAL_8250_NR_UARTS=32
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
Recompiling would let you set the parameters in the kernel itself (and maybe have more than 32 serial ports?).

The easy way to fix this is (as root) to edit /etc/default/grub and append " 8250.nr_uarts=8" (without quotes) to the end of the line "GRUB_CMDLINE_LINUX_DEFAULT=". It might then look like :

GRUB_CMDLINE_LINUX_DEFAULT="quiet 8250.nr_uarts=8"
You can set any number up to 32 as the number of serial ports this way.

You then have to run "update-grub" as root. After rebooting you should have the serial ports working.

-----------------------







Kernel command line
nr_uarts=       [SERIAL] maximum number of UARTs to be registered.




Problem initialising more than 4 serial ports (Resolved)
Post by andrewloz » 2016/01/24 01:58:09

Using a WADE 8015 board which has 6-7 serial devices, the kernel improperly initialises the serial hardware - so far as I can tell, none of the ports work properly with the default configuration.

The resolution turns out to be pretty simple (at least for this board, most likely others too). Simply set the number of ports to initialise to be enough for all the hardware: for this board, set 8250.nr_uarts=7 on the boot command line. After which the kernels sets up the ports exactly as expected and furthermore, they work as expected also.

For those that don't regularly change the grub configuration, the mechanics are:
Edit /etc/default/grub and add 8250.nr_uarts=7 to the line starting GRUB_CMDLINE_LINUX=... (change the 7 to what is required for your card. Allow for IR ports also.)
Run grub2-mkconfig -o /boot/grub2/grub.cfg
Reboot













15. Serial Tips And Miscellany
15.1 Serial Modules
Often the serial driver is provided as a module(s) such as generic_serial.ko. Drivers for USB serial ports and multiport cards are often provided as modules. Linux should automatically load any needed module, so in most cases you have nothing to do.

But sometimes you need to configure Linux to load certain modules or gives parameters to the module or to the kernel.

Such parameters may be supplied to certain modules on the command line for the kernel or in /etc/modules, /etc/modules.conf or /etc/modprobe.conf. Since kernel 2.2 you don't edit the modprobe.conf file but use the program update-modules to change it. The info that is used to update modules.conf is put in /etc/modutils/.

The Debian/GNU Linux has a file named /etc/modutils/setserial which runs the serial script in /etc/init.d/ every time the serial module is loaded or unloaded. When the serial module is unloaded this script will save the state of the module in /var/run/setserial.conf. Then if the module loads again this saved state is restored. When the serial module first loads at boot-time, there's nothing in /var/run/setserial.conf so the state is obtained from /etc/serial.conf. So there are two files that save the state. Other distributions may do something similar.

Serial modules are found in subdirectories of /lib/modules/.../kernel/drivers/. For multiport cards, look in the serial subdirectory and/or char. For USB serial, look in the usb/serial subdirectory. The module, parport_serial is for PCI cards that contain both serial and parallel ports.

As a last resort, one may modify the serial driver by editing the source code. Much of the serial driver is found in the file serial.c. For info regarding writing of programs for the serial port see Serial-Programming-HOWTO. It was revised in 1999 by Vern Hoxie but that revision is not at LDP.

15.2 Kernel Configuration
15.3 Number of Serial Ports Supported
If you have more than 4 (or possibly 2) serial ports, then you must insure that the kernel knows this. It can be done by configuring the kernel when compiling or by a parameter given to the kernel when it starts (boot-prompt or kernel command line).

The kernel configuration parameters: CONFIG_SERIAL_8250_RUNTIME_UARTS=4 and CONFIG_SERIAL_8250_NR_UARTS=4 set the maximum number of ordinary serial ports (UARTs) equal to 4. If you have more than 4 ordinary serial ports, then you need to change the 4 to whatever. But you may override this via the kernel command line for example: nr_uarts=16 (if serial support built into the kernel) or 8250.nr_uarts=16 (if serial support is via a module). The boot loader such as lilo or grub can be told to do this.

15.4 Serial Console (console on the serial port)
See the kernel documentation in: Documentation/serial-console.txt. Kernel 2.4+ has better documentation. See also "Serial Console" in Text-Terminal-HOWTO.

15.5 Line Drivers
For a text terminal, the RS-232 speeds are fast enough but the usable cable length is often too short. Balanced technology could fix this. The common method of obtaining balanced communication with a text terminal is to install 2 line drivers in the serial line to convert unbalanced to balanced (and conversely). They are a specialty item and are expensive if purchased new.

15.6 Stopping the Data Flow when Printing, etc.
Normally flow control and/or application programs stop the flow of bytes when its needed. But sometimes they don't. The problem is that output to the serial port first passes thru the large serial buffer in the PC's main memory. So if you want to abort printing, whatever is in this buffer should be removed. When you tell an application program to stop printing, it may not empty this buffer so printing continues until it's empty. In addition, your printer has it's own buffer which needs to be cleared. So telling the PC to stop printing may not work due to these two buffers that continue to supply bytes for the printer. It's a problem with printer software not knowing about the serial port and that modem control lines need to be dropped to stop the printer.

One way to insure that printing stops is to just turn off the printer. With newer serial drivers, this works OK. The buffers are cleared and printing doesn't resume. With older serial drivers, the PC's serial buffer didn't clear and it would sometimes continue to print when the printer was turned back on. To avoid this, you must wait a time specified by setserial's closing_wait before turning the printer back on again. You may also need to remove the print job from the print queue so it won't try to resume.

15.7 Known IO Address Conflicts
Avoiding IO Address Conflicts with Certain Video Boards
The IO address of the IBM 8514 video board (and others) is allegedly 0x?2e8 where ? is 2, 4, 8, or 9. This may conflict (but shouldn't if the serial port is well designed) with the IO address of ttyS3 at 0x02e8 if the serial port ignores the leading 0 hex digit when it decodes the address (many do). That is bad news if you try to use ttyS3 at this IO address. Another story is that Linux will not detect your internal modem on ttyS3 but that you can use setserial to put ttyS3 at this address and the modem will work fine.

IO address conflict with ide2 hard drive
The address of ttyS2 is 3e8-3ef while hard drive ide2 uses 3ee which is in this range. So when booting Linux you may see a report of this conflict. Most people don't use ide2 (the 3rd hard drive cable) and may ignore this conflict message. You may have 2 hard drives on ide0 and two more on ide1 so most people don't need ide2.

15.8 Known Defective Hardware
Problem with AMD Elan SC400 CPU (PC-on-a-chip)
This has a race condition between an interrupt and a status register of the UART. An interrupt is issued when the UART transmitter finishes the transmission of a byte and the UART transmit buffer becomes empty (waiting for the next byte). But a status register of the UART doesn't get updated fast enough to reflect this. As a result, the interrupt service routine rapidly checks and determines (erroneously) that nothing has happened. Thus no byte is sent to the port to be transmitted and the UART transmitter waits in vain for a byte that never arrives. If the interrupt service routine had waited just a bit longer before checking the status register, then it would have been updated to reflect the true state and all would be OK.

There is a proposal to fix this by patching the serial driver. But Should linux be patched to accommodate defective hardware, especially if this patch may impair performance of good hardware?
