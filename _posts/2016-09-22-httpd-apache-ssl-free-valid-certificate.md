---
layout: single
title: HTTPD Apache SSL configuration with a FREE valid certificate
description: "Demo post displaying the various ways of highlighting code in Markdown."
category: articles
tags: [httpd, https, ssl, certificate]
author_profile: true
comments: true
share: true
related: true
---

HTTPD Apache SSL configuration with a FREE valid certificate

This simple guide will show how to configure https in the Amazon EC2 instance with the operating system
Amazon Linux AMI or Cent OS.
At the end of this configuration any request to 
yoursite.com or www.yoursite.com will be redirected to https://www.yoursite.com
And the site will have a valid certificate, if your try use a self signed certificate you should receive one error like this: http://www.fixedbyvonnie.com/wp-content/uploads/2015/06/fixedbyvonnie-invalid-certificate.jpg
So we will generate a valid certificate with [certbot](https://certbot.eff.org/).

- Install apache, php and ssl
yum install httpd mod_ssl git

This command will install the [HTTPD Apache](https://httpd.apache.org/), that is a simple server, the [mod_ssl](https://httpd.apache.org/docs/current/mod/mod_ssl.html), that is a module of Apache to cryptography using the Secure Sockets Layer (SSL) and Transport Layer Security (TLS) protocols and the [git](https://git-scm.com/) that is one version control system that we will use just to download the project that will generate our certificate. 

- Disable welcome page of Apache
sudo rm -rf /etc/httpd/conf.d/welcome.conf

By default Apache come with a welcome page, to disable this page we just need remove the conf file that do this.
Now just for test you can create one file called index.html in the /var/www/html/ and run
sudo service httpd start
then try access yourdomain.com, should work but without https.

- Generating the certificate

Now we can begin the game, generate the certificate...

# Download the certbot project
git clone https://github.com/certbot/certbot.git
cd certbot

This command will download the last version of the certbot to your machine.

# Run the command that generate the certificate
./letsencrypt-auto certonly --debug

# Select the first option:
Place files in webroot directory

# Write the domain address, ex.: 
luxysale.com www.luxysale.com

# Select the root apache folder 
/var/www/html/

#  When the script finish, the certificates will be generated in the folder:
/etc/letsencrypt/live/luxysale.com/

# With the content:
cert.pem   fullchain.pem chain.pem  privkey.pem

- Renew the certificate
# To renew the certificate just go to the folder certbot and execute:
./letsencrypt-auto renew

- Setting the new certificate in apache
# Edit the file /etc/httpd/conf.d/ssl.conf, and edit/include the follow properties:
ServerName luxysale.com
ServerAlias www.luxysale.com
SSLCertificateFile /etc/letsencrypt/live/luxysale.com/cert.pem
SSLCertificateKeyFile /etc/letsencrypt/live/luxysale.com/privkey.pem
SSLCertificateChainFile /etc/letsencrypt/live/luxysale.com/fullchain.pem

- Enabling redirect from http to https
# Edit the file /etc/httpd/conf/httpd.conf, and include the follow lines at the end of file:
<VirtualHost *:80>
  ServerName www.luxysale.com
  Redirect "/" "https://www.luxysale.com/"
</VirtualHost>

- Troubleshooting

# Try install ssl_mod and httpd at the same time, when I tried to install ssl_mod with an already installed version of httpd occurred compatibility errors and ended up having to remove it and install again. 
To remove everything and start again run the commands:

yum remove php* 
yum remove httpd* 


