# Prepare

After installation  from USB (netinst)

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


