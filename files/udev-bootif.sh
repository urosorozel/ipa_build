#!/usr/bin/env bash

BOOT_MAC=$(/bin/cat /proc/cmdline | egrep -o  'BOOTIF=([^ ]+)')
BOOT_MAC=${BOOT_MAC//-/:}
BOOT_MAC=${BOOT_MAC#*:}
cat > /etc/udev/rules.d/70-bootif.rules  <<EOF
SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="$BOOT_MAC", ATTR{type}=="1", NAME="enoboot0"
EOF

cat > /etc/systemd/network/bond0.link <<EOF
[Match]
Name=bond0

[Link]
MACAddress=${BOOT_MAC}
EOF
