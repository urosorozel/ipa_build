#!/usr/bin/env bash

BOOT_MAC=$(/bin/cat /proc/cmdline | egrep -o  'BOOTIF=([^ ]+)')
BOOT_MAC=${BOOT_MAC//-/:}
BOOT_MAC=${BOOT_MAC#*:}
cat > /etc/udev/rules.d/70-bootif.rules  <<EOF
SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="$BOOT_MAC", ATTR{type}=="1", NAME="enoboot0"
EOF
