#/bin/bash

mkdir ~/packages

cp -R /etc/apt/sources.list 

cp /etc/apt/sources.list.d/ ~/packages/

sudo dpkg --get-selections > ~/packages/package.list 

tar cPvzf ~/packages-`date +%Y-%m-%d`.tar.gz ~/packages/ 

rm -rf ~/packages/

