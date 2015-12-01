#!/bin/bash

# check and cleanup files from previous versions
echo "cleanup old versions bits"
rm -f /storage/.config/jc600-asound.conf
rm -f /storage/.config/jc601-asound.conf
rm -f /storage/.config/purge_manager.sh
# on frodo to gotham updates, nuke guisettings.xml, too much has changed.
FILE="/storage/.xbmc/userdata/guisettings.xml"
if grep -q "haslcd" $FILE; then
  echo "updating guisettings from frodo to gotham"
  rm -f $FILE
fi


# setup dual analog/hdmi audio output
# only one of the below audio devices will be present
echo "setting up dual audio"
SIG_JC600="/proc/asound/Device"
SIG_JC601="/proc/asound/Intel"
SIG_JC310="/proc/asound/PCH"
if [ -d "$SIG_JC600" ]; then
  echo "found" $SIG_JC600
  cp -rf /usr/share/nationwide/jc600-asound.conf /storage/.config/asound.conf
fi
if [ -d "$SIG_JC601" ]; then
  echo "found" $SIG_JC601
  cp -rf /usr/share/nationwide/jc601-asound.conf /storage/.config/asound.conf
fi
if [ -d "$SIG_JC310" ]; then
  echo "found" $SIG_JC310
  cp -rf /usr/share/nationwide/jc310-asound.conf /storage/.config/asound.conf
fi

# setup webinterface.nationwide_membernet
# so we can get to it from the addon service
/bin/mkdir -p /storage/.xbmc/addons
#
WEBINTERFACE_SRC=/usr/config/webinterface.nationwide_membernet
WEBINTERFACE_DST=/storage/.config/webinterface.nationwide_membernet
/bin/ln -sf $WEBINTERFACE_DST /storage/.xbmc/addons/webinterface.nationwide_membernet
# on 1st boot, OpenElec will populate /storage/.config/webinterface.nationwide_membernet,
# once present, OpenElec will skip the population so we have to handle update it ourself.
if [ -d "$WEBINTERFACE_DST" ]; then
  # save the old settings.txt, and remove everything from old
  mv -f $WEBINTERFACE_DST/settings.txt /tmp/settings.txt
  rm -rf $WEBINTERFACE_DST/*
  # copy in new, cp is setup to NOT overwrite existing files (settings.txt)
  cp -rf $WEBINTERFACE_SRC/* $WEBINTERFACE_DST/
  # restore old settings.txt
  mv -f /tmp/settings.txt $WEBINTERFACE_DST/settings.txt
  # last update the current settings.txt for any missing settings
  # url:feed added in v4.1.5
  /usr/bin/python /usr/share/nationwide/update_webui.py $WEBINTERFACE_DST/settings.txt
fi

# nuke any existing repositorys
rm -rf /storage/.xbmc/addons/repository.*

# make sure time is right
(
  /bin/sleep 30; \
  /usr/sbin/ntpdate pool.ntp.org;
)&

# startup purge manager
(
  /bin/bash /usr/share/nationwide/purge_manager.sh
)&
