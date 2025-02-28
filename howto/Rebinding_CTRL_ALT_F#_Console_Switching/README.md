# Issue
If you use an application that binds CTRL+ALT+F7, but your linux machine seems to catch the keystroke.
Is there a way to rebind/disable this key? A recompile of the kernel is an acceptable answer.

# Solution
The following invocation of the X11 _setxkbmap_ command disables Ctrl-Alt-Fn console/virtual terminal switching:

```
setxkbmap -option srvrkeys:none
```

To return to the previous behavior of the _ctrl-alt-Fn_ keys, and also remove all other options, such as _caps:ctrl_modifier_:

```
setxkbmap -option ''
```

To print the current settings invoke _setxkbmap -print_.

To invoke per user, put the command in the _~/.xinitrc_ file.

To invoke when an Xsession starts, create a file in _/etc/X11/Xsession.d_ such as

```
/etc/X11/Xsession.d/65srvrkeys-none
```

containing the above setxkbmap command, and make it executable with 

```
sudo chmod +x /etc/X11/Xsession.d/65srvrkeys-none.
```

For more information type man setxkbmap at your shell prompt or see the Xorg setxkbmap man page.

I tested this with Ubuntu 22.04 LTS. These settings are also available in _System Settings > Input Devices > Keyboard > Advanced_. 
If you change srvrkeys in the GUI Settings, it shows up immediately in setxkbmap and vice versa.

I prefer to modify the X window system via the X11 command line interfaces. 
If that does not work, then I attempt the desktop environment. As a last resort I would modify system configuration files. 
Implementations and file formats change, but command line interfaces live almost forever in the Unix/Linux tradition.
