#!/usr/bin/sh


dnf install powertop tlp tlp-rwd -y
dnf remove power-profiles-daemon -y

tlp start

sed -i "s|defaults|defaults,noatime|" /etc/fstab
