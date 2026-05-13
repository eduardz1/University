#!/bin/bash

NS1="129.88.46.51"
TARGET="openbar.today"

# Get ns2 IP
NS2=$(dig @$NS1 ns2.$TARGET +short)

# Test zone transfers on both nameservers
for ns in $NS1 $NS2; do
    echo "[*] Testing AXFR on $ns"
    dig @$ns AXFR $TARGET
done

# Try reverse DNS on IPv4 and IPv6
dig -x $NS1
dig -x 2001:660:5301:46::46:51

# Test common nameserver subdomains
for sub in {ns,ns1,ns2,ns3,dns1,dns2}; do
    echo "[*] Testing $sub.$TARGET"
    dig @$NS1 $sub.$TARGET ANY +nocookie
done

# Attempt IXFR
dig @$NS1 IXFR $TARGET