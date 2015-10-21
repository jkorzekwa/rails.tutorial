#!/usr/bin/env bash

# Remove database and app startup
sudo service toy stop
sudo rm -rf /etc/toy/
sudo rm /etc/init.d/toy
sudo update-rc.d -f toy remove

