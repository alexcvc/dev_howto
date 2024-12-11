# How to obtain all connections

1. Edit the Mosquitto configuration file ( /etc/mosquitto/conf.d/mosquitto.conf ) and add these lines:
```
allow_anonymous true
listener 1883 0.0.0.0
```
2. Restart Mosquitto as a service
```
$ sudo service mosquitto restart
```

or not a service
```
$ mosquitto --verbose --config-file /etc/mosquitto/conf.d/mosquitto.conf
```

Check log messages `/var/log/mosquitto/mosquitto.log'

3. Test 

Use the --host (-h) parameter and the host IP address to run Mosquitto Subscriber/Publisher.
Get the IP of the browser from the ifconfig or ip -color addr command).
