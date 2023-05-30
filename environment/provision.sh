
# be careful of these keys, they will go out of date
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv D68FA50FEA312927
echo "deb https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | sudo$

sudo apt-get update -y
sudo apt-get upgrade -y

# sudo apt-get install mongodb-org=3.2.20 -y
sudo apt-get install -y mongodb-org=3.2.20 mongodb-org-server=3.2.20 mongodb-org-shell=$

# remoe the default .conf and replace with our configuration
#sudo rm /etc/mongod.conf
#sudo ln -s /home/ubuntu/environment/mongod.conf /etc/mongod.conf

# Change bindIp from 127.0.0.1 to specific IP of app (e.g. 192.168.10.150)
# (we could use 0.0.0.0 but this allow any IPs to connect to it)
sudo apt install sed
sudo sed -i "s/bindIp: 127.0.0.1/bindIp: 0.0.0.0/" /etc/mongod.conf

# if mongo is is set up correctly these will be successful
sudo systemctl restart mongod
sudo systemctl enable mongod
