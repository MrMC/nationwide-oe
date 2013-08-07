#!/bin/sh

/bin/mkdir -p /storage/.xbmc/addons
/bin/ln -s /storage/.config/webinterface.nationwide_membernet /storage/.xbmc/addons/webinterface.nationwide_membernet

(
  /bin/sleep 30; \
  /usr/sbin/ntpdate pool.ntp.org; \
)&
