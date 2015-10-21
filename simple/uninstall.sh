#!/usr/bin/env bash

# Remove database and app startup
sudo rm -rf /etc/simple/
sudo rm /etc/init.d/simple
sudo update-rc.d -f simple remove

