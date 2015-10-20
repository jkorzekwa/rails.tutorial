#!/usr/bin/env bash
# Create db directory
sudo mkdir -p /etc/simple/db
sudo chmod -R 777 /etc/simple
# Copy init script to /etc/init.d
sed -i "s/^export $SIMPLE_APP_HOME=.*/export $SIMPLE_APP_HOME=`pwd`/" simple_init
sudo chmod a+x simple_init
sudo cp simple_init /etc/init.d/simple
sudo update-rc.d simple defaults
# Add simple app path to env vars
cd ../
export SIMPLE_APP_HOME=`pwd`


