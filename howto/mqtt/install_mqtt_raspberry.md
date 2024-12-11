# Installing the Mosquitto MQTT Server to the Raspberry Pi

## Installation

1. Update the operating system.

```
sudo apt update
sudo apt upgrade
```

2. Once the system has finished updating, install the Mosquitto software.

Mosquitto MQTT broker is available as part of the Raspbian repository, so installing the software is simple.

```
sudo apt install mosquitto mosquitto-clients
```


3. Mosquitto MQTT broker up and running on device.

```
sudo systemctl status mosquitto
```

This command will return the status of the `mosquitt` service.

You should see the text `active (running)` if the service has started up properly.

## Testing the Mosquitto Installation on the Raspberry Pi

We will use the Mosquitto client to do this.
You will need to open two terminal sessions on your Raspberry Pi (either locally or via SSH).

1. Setup of a subscriber. The subscriber will be the listen for MQTT broker on the Raspberry Pi.

```
mosquitto_sub -h localhost -t "mqtt/test"
```

2. Now that we have a client loaded and listening for messages, we can try to publish one to it.
We need to use the MQTT publisher client that we installed on our Raspberry Pi earlier to publish a message to the topic.
Run the following command to publish the message "Hello World" to our localhost server under the topic "mqtt/test".

```
mosquitto_pub -h localhost -t "mqtt/test" -m "Hello world"
```

Two of the arguments are the same as the previous command, with `-h` specifying the server to connect to and `-t` specifying the topic to publish to.


## How to obtain all connections

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
