#!/bin/bash
###### Created By Kamleshwar Prasad Gupta######
yum install -y httpd
service  httpd start
chkconfig httpd on
echo "<html><h1>Hello from Kamleshwar ^^</h2></html>" > /var/www/html/index.html
