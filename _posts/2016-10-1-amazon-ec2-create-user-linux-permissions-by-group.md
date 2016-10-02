---
layout: single
title: Amazon EC2 create new user with Linux Permissions by Group
description: "Guide how to use Docker in day to day as a Java Developer."
category: articles
tags: [linux, group, permissions, ec2, amazon, new, user, ssh, ftp]
author_profile: true
comments: true
share: true
related: true
---

This little step by step will guide your through the creation of one new user in one Amazon EC2 Instance.
At the end, we will have a group that can be added to any folder to give permission of access to our new user.

* Create a new user

~~~ bash
sudo useradd myNewUser
~~~


* Create a new group 

~~~ bash
sudo addgroup dev #Debian
sudo groupadd dev #CentOS
~~~

* Add new user in the new group

~~~ bash
sudo usermod -a -G dev myNewUser
~~~

* List the groups of the user, just to verify

~~~ bash
groups myNewUser
> myNewUser : myNewUser dev
~~~

* If you want that the default user has permission to this group too, do

~~~ bash
sudo usermod -a -G dev ubuntu #Debian
sudo usermod -a -G dev ec2-user #CentOS
~~~

* Create my test folder with root permission

~~~ bash
sudo mkdir /var/testFolder
~~~

* List permissions of test folder

~~~ bash
cd /var/www/ && ls -lha
> drwxr-xr-x  2 root     root     4,0K Set 30 12:11 testFolder
~~~

* Just to explain in this string "drwxr-xr-x 2 root root"

drwxr: Owner of the folder permission, in our case root permissions

xs: Group folder permissions

x: All others users permissions (not root and not in the group)

First root: Folder owner

Second root: Group of the folder

To one better explanation, please check [this link](https://www.garron.me/en/go2linux/ls-file-permissions.html)

* Change the group of the folder to dev

~~~ bash
sudo chown -R root:dev /var/testFolder
~~~

* List permissions of my test folder

~~~ bash
ls -lha
> drwxr-xr-x  2 root     dev      4,0K Set 30 12:11 testFolder
~~~

* \o/ now the group of the folder is dev

* Add permissions to dev group in this folder 

~~~ bash
sudo chmod g=rwx -R /var/testFolder
~~~

* List permissions to the folder

~~~ bash
ls -lha
> drwxrwxr-x  2 root     dev      4,0K Set 30 12:11 testFolder
~~~

* Now we have one new user and one folder to test, but to access the Amazon Instance through ssh we need create a new private key to this user and configure the public key in the server.


* Generate amazon private key and download to your machine (not to the server)
[Amazon User Guide create your key pair](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html#having-ec2-create-your-key-pair)


* Change permission of the private key 

~~~ bash
chmod 600 privateKeyFileFromAmazon.pem
~~~

* Export the public key to one file, this public key is what we will use in our Amazon Server

~~~ bash
ssh-keygen -y -f myNewUser.pem > publicmyNewUser.txt
~~~

* Go to Amazon with the root user (default)

~~~ bash
ssh -i ~/.ssh/mainUserKey.pem ec2-user@52.18.60.59
~~~

* Login with the new user

~~~ bash
sudo su - myNewUser
~~~

* Now you should be redirected to the home folder of the your user, like '/home/myNewUser/'

* Create ssh folder and change permissions

~~~ bash
mkdir .ssh && chmod 700 .ssh
~~~


* Create authorized_keys and change the permission 

~~~ bash
touch .ssh/authorized_keys && chmod 600 .ssh/authorized_keys
~~~

* Now just copy the public key from publicmyNewUser.txt to the authorized_keys file, the instance will use this public key to check if our private key is valid when we try connect

* Get out from the server and try connect with the new user

~~~ bash
ssh -i ~/.ssh/myNewUser.pem myNewUser@52.18.60.59
~~~

* Try access one folder that you do not have permission, like root user folder

~~~ bash
cd /home/ec2-user #centos 
cd /home/ubuntu #ubuntu
~~~

* You should receive something like

~~~ bash
> -bash: cd: /home/ec2-user: Permission denied
~~~

* And try access our test folder that have the group dev 

~~~ bash
cd /var/testFolder
touch test.txt
~~~


### Troubleshooting

#### Error ssh access denied when try access the server with the new user
* Check if the files and folder of the server in .ssh have the correct permissions like described 
* Check if the content of authorized_keys is equals to the result of the command ssh-keygen -y -f myNewUser.pem
* Check if myNewUser.pem have the permission 600

#### Permission denied when try create one file with the default user (like ec2-user or ubuntu)
* Check if you add this user to the group (check the begin of the tutorial to this)
* Try just exit of the server and login again (when you change one group of one user is necessary login again, yeh like Windows)


 
