#!/bin/bash

# check and cleanup files from previous versions
rm -f /storage/.config/jc600-asound.conf
rm -f /storage/.config/jc601-asound.conf
rm -f /storage/.config/purge_manager.sh

# setup dual analog/hdmi audio output
# only one of the below audio devices will be present
SIG_JC600="/proc/asound/Device"
SIG_JC601="/proc/asound/Intel"
if [ -d "$SIG_JC600" ]; then
  cp -rf /usr/share/nationwide/jc600-asound.conf /storage/.config/asound.conf
fi
if [ -d "$SIG_JC601" ]; then
  cp -rf /usr/share/nationwide/jc601-asound.conf /storage/.config/asound.conf
fi

# setup webinterface.nationwide_membernet
# so we can get to it from the addon service
/bin/mkdir -p /storage/.xbmc/addons
/bin/ln -sf /storage/.config/webinterface.nationwide_membernet /storage/.xbmc/addons/webinterface.nationwide_membernet

# make sure time is right
(
  /bin/sleep 30; \
  /usr/sbin/ntpdate pool.ntp.org; \
)&

# startup purge manager
(
  /bin/bash /usr/share/nationwide/purge_manager.sh
)&
