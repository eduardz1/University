#!/bin/bash

# 1. Try other CHAOS class queries
dig CH TXT hostname.bind @openbar.today
dig CH TXT id.server @openbar.today
dig CH TXT authors.bind @openbar.today

# 2. Check for zone transfer with found info
dig @129.88.46.51 AXFR openbar.today

# 3. Look for other BIND-specific queries
dig @openbar.today HINFO
dig @openbar.today TXT