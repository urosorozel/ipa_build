#!/usr/bin/env bash

BOOT_MAC=$(/bin/cat /proc/cmdline | egrep -o  'BOOTIF=([^ ]+)')
BOOT_MAC=${BOOT_MAC//-/:}
# Remove leading 00: if mac is 20 chars long
if [ ${#BOOT_MAC} -eq 20 ];then
  BOOT_MAC=${BOOT_MAC#*:}
else
  BOOT_MAC=${BOOT_MAC#*=}
fi
SECONDARY=$(echo "from netaddr import * ; mac=EUI('$BOOT_MAC'); mac.value = mac.value + 1; mac.dialect = mac_unix_expanded; print(mac)" | python)
cat > /etc/udev/rules.d/70-bootif.rules  <<EOF
SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="$BOOT_MAC", ATTR{type}=="1", NAME="enoboot0"
SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="$SECONDARY", ATTR{type}=="1", NAME="enoboot1"
EOF
