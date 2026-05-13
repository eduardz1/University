#!/bin/bash

TARGET="openbar.today"

# 1. Test AXFR on common DNS servers
for ns in $(dig NS $TARGET +short); do
    echo "Testing AXFR on $ns..."
    dig @$ns AXFR $TARGET
done

# 2. Check IXFR
dig @$TARGET IXFR $TARGET

# 3. Test recursion
dig +recurse @$TARGET test.com

# 4. Check version
dig CH TXT version.bind @$TARGET

# 5. Test cache snooping
dig @$TARGET +nocache +norecurse google.com

# 6. Bonus: Quick subdomain enumeration
for sub in {www,dev,test,staging,admin}; do
    dig @$TARGET $sub.$TARGET +nocache +norecurse
done