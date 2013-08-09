#!/bin/sh

/bin/mkdir -p /storage/.xbmc/addons
/bin/ln -s /storage/.config/webinterface.nationwide_membernet /storage/.xbmc/addons/webinterface.nationwide_membernet 2>/dev/null

(
  /bin/sleep 30; \
  /usr/sbin/ntpdate pool.ntp.org; \
)&
