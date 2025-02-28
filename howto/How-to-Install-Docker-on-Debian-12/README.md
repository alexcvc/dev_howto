How to Install Docker on Debian 12 Step-by-Step
===

Prerequisite:

- Minimal Debian 12 Installation
- 64-bit System
- Stable Internet Connection
- Sudo user with admin access.

Without any further delay, let’s jump into Docker Installation steps,

1) Update Apt Package Index

Login to your Debian 12  system, open the terminal and run below command to update apt package index

```
$ sudo apt update
$ sudo apt install -y ca-certificates curl gnupg
```

2) Add Docker Repository

To add docker repository, let’s first add Docker’s GPG key via following curl command.

```
$ sudo install -m 0755 -d /etc/apt/keyrings
$ curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
$ sudo chmod a+r /etc/apt/keyrings/docker.gpg
```

Next, run echo command to add official docker repository.

`
$ echo \
"deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
"$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
`
`

Output of above command,

Add-Docker-Repo-Debian12

3) Install Docker Engine

Now it’s time to install Docker itself, run the following apt commands to install docker engine,

```
$ sudo apt update
$ sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
```

Apt-Install-Docker-Debian12

Once the docker is installed successfully then it’s service starts automatically. Verify its version and service status by running,

```
$ sudo docker version
```

Docker-Version-Check-Debian12

```
$ sudo systemctl status docker
```

Docker-Service-Status-Debian12

Above output confirm that, docker service is up and running. In case docker service is not running then try to start its service using beneath command.

```
$ sudo systemctl start docker
```

4) Verify Docker Installation

To verify the docker installation, try to spin up a ‘hello-world’ container and see whether informational message is displayed or not.

In order to spin up ‘hello-world’ container, run below docker command with sudo

```
$ sudo docker run hello-world
```

Docker-run-hello-world-Debian12

Above informational message confirms that docker is working properly.

5) Allow Local User to Run Docker Command

To allow local user to run docker commands without sudo, add the user to docker group (secondary group) using usermod command.

```
$ sudo usermod -aG docker $USER
$ newgrp docker
```

Removal of Docker

In case you are done with docker testing and want to remove docker from your system completely then run following commands to uninstall it,

```
$ sudo apt purge docker-ce docker-ce-cli containerd.io \
docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras -y
$ sudo rm -rf /var/lib/docker
$ sudo rm -rf /var/lib/containerd
```


