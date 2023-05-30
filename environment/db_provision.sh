#!/bin/bash

# Provisioning for db vm
# Update the sources list
sudo apt-get update -y

# upgrade any packages available
sudo apt-get upgrade -y

# Add the Key:
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv D68FA50FEA312927  

# Make Sure its Working
echo "deb https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list

# It will display back - deb https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse
# Update and Upgrade the system
sudo apt-get update -y

sudo apt-get upgrade -y

# Install database - sudo apt-get install mongodb-org=3.2.20 -y
sudo apt-get install -y mongodb-org=3.2.20 mongodb-org-server=3.2.20 mongodb-org-shell=3.2.20 mongodb-org-mongos=3.2.20 mongodb-org-tools=3.2.20

# Change bindIp from 127.0.0.1 to specific IP of app (e.g. 192.168.10.150)
# (we could use 0.0.0.0 but this allow any IPs to connect to it)
sudo apt install sed
sudo sed -i "s/bindIp: 127.0.0.1/bindIp: 0.0.0.0/" /etc/mongod.conf

# Start mongodb and enable it
sudo systemctl start mongod

sudo systemctl enable mongod

echo "Show whether mongo db is running..."
sudo systemctl status mongod