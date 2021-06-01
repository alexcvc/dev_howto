#/bin/bash

mkdir ~/packages 

tar xPvzf ~/packages-*.tar.gz

cp ~/packages/sources.list /etc/apt/sources.list

cp ~/packages/sources.list.d/* /etc/apt/sources.list.d/

apt-get update

dpkg --set-selections < ~/packages/package.list

apt-get install --yes dselect

dselect update
 
apt-get dselect-upgrade

