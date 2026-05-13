#!/bin/bash

TARGET="openbar.today"
IP="129.88.46.51"

# Check all common DNS record types
for type in A AAAA NS MX TXT SRV PTR HINFO SOA; do
    echo "[*] Checking $type records"
    dig @$IP $type $TARGET
done

# Try DNSSEC records
for type in DNSKEY DS RRSIG NSEC NSEC3; do
    echo "[*] Checking DNSSEC $type records"
    dig @$IP $type $TARGET +dnssec
done

# Test for common subdomains with different record types
for subdomain in {www,dev,stage,test,admin,internal}; do
    for type in A AAAA TXT; do
        echo "[*] Testing $subdomain.$TARGET ($type)"
        dig @$IP $type $subdomain.$TARGET +short
    done
done

# Check for DNS cache poisoning
dig @$IP $TARGET +dnssec +cd