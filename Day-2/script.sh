#!/bin/bash
sudo yum install httpd -y
sudo service httpd start
sudo systemctl enable httpd
echo "Hi, Everyone this coming through httpd by terraform" > /var/www/html/index.html