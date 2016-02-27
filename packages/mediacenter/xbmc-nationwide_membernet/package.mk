################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2014 Stephan Raue (stephan@openelec.tv)
#
#  OpenELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  OpenELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

PKG_NAME="xbmc-nationwide_membernet"
PKG_VERSION="4.2.5"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="prop."
PKG_SITE="http://www.nationwidegroup.org"
PKG_SOURCE_DIR="$PKG_NAME"
PKG_DEPENDS_TARGET="toolchain Python connman pygobject dbus-python xbmc"
PKG_PRIORITY="optional"
PKG_SECTION="mediacenter"
PKG_SHORTDESC="xbmc-nationwide_membernet: nationwide membernet services"
PKG_LONGDESC="xbmc-nationwide_membernet: nationwide membernet services"
PKG_GITVERSION="e427994fe9569f9d885a7d8da2243e89dcfeb636"
PKG_GITURL="git@github.com:nicholasstokes/addons.nationwide.git"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"


make_target() {
  DIR_ON_ENTRY=`pwd`
  #echo "make_target PKG_BUILD->" $PKG_BUILD
  #echo "make_target DIR_ON_ENTRY->" $DIR_ON_ENTRY

  rm -rf addons.nationwide.git
  git clone $PKG_GITURL addons.nationwide.git >/dev/null
  cd addons.nationwide.git
  git checkout -b $PKG_GITVERSION >/dev/null

  cd $DIR_ON_ENTRY
  cd addons.nationwide.git/service.openelec.settings
    python -Wi -t -B $ROOT/$TOOLCHAIN/lib/python2.7/compileall.py ./resources/lib/ -f >/dev/null
    rm -rf `find ./resources/lib/ -name "*.py"`
    python -Wi -t -B $ROOT/$TOOLCHAIN/lib/python2.7/compileall.py ./oe.py -f >/dev/null
    rm -rf ./oe.py

  cd $DIR_ON_ENTRY
  cd addons.nationwide.git/script.nationwide_helper
    #python -Wi -t -B $ROOT/$TOOLCHAIN/lib/python2.7/compileall.py ./resources/lib/ -f
    #rm -rf `find ./resources/lib/ -name "*.py"`

  cd $DIR_ON_ENTRY
  cd addons.nationwide.git/script.nationwide_membernet
    python -Wi -t -B $ROOT/$TOOLCHAIN/lib/python2.7/compileall.py ./resources/lib/ -f >/dev/null
    rm -rf `find ./resources/lib/ -name "*.py"`

  cd $DIR_ON_ENTRY
  cd addons.nationwide.git/skin.nationwide
    TexturePacker -input ./media -output ./Textures.xbt -dupecheck -use_none > /dev/null 2>&1

  cd $DIR_ON_ENTRY
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/share/xbmc/addons/service.openelec.settings
    rm -rf $INSTALL/usr/share/xbmc/addons/service.openelec.settings/*
    cp -R addons.nationwide.git/service.openelec.settings/* $INSTALL/usr/share/xbmc/addons/service.openelec.settings

  mkdir -p $INSTALL/usr/share/xbmc/addons/script.nationwide_helper
    cp -R addons.nationwide.git/script.nationwide_helper/* $INSTALL/usr/share/xbmc/addons/script.nationwide_helper

  mkdir -p $INSTALL/usr/share/xbmc/addons/script.nationwide_membernet
    cp -R addons.nationwide.git/script.nationwide_membernet/* $INSTALL/usr/share/xbmc/addons/script.nationwide_membernet

  mkdir -p $INSTALL/usr/config/webinterface.nationwide_membernet
    cp -R addons.nationwide.git/webinterface.nationwide_membernet/* $INSTALL/usr/config/webinterface.nationwide_membernet

  rm -rf $INSTALL/usr/share/xbmc/addons/skin.nationwide
  mkdir -p $INSTALL/usr/share/xbmc/addons/skin.nationwide/media
    cp -R addons.nationwide.git/skin.nationwide/*/ $INSTALL/usr/share/xbmc/addons/skin.nationwide
    cp addons.nationwide.git/skin.nationwide/*.txt $INSTALL/usr/share/xbmc/addons/skin.nationwide 2>/dev/null || :
    cp addons.nationwide.git/skin.nationwide/*.xml $INSTALL/usr/share/xbmc/addons/skin.nationwide 2>/dev/null || :
    cp addons.nationwide.git/skin.nationwide/*.png $INSTALL/usr/share/xbmc/addons/skin.nationwide 2>/dev/null || :
    cp addons.nationwide.git/skin.nationwide/Textures.xbt $INSTALL/usr/share/xbmc/addons/skin.nationwide/media

  mkdir -p $INSTALL/usr/share/nationwide
    cp -f $PKG_DIR/scripts/* $INSTALL/usr/share/nationwide/

  mkdir -p $INSTALL/etc
    echo "$PKG_VERSION" > $INSTALL/etc/version.nationwide_membernet

  # overriding XBMC’s Splash image
  mkdir -p $INSTALL/usr/share/xbmc/media
    cp -f $PKG_DIR/splash/splash.png $INSTALL/usr/share/xbmc/media/Splash.png

  mkdir -p $INSTALL/usr/config
    cp -PR $PKG_DIR/config/* $INSTALL/usr/config
}

post_install() {
  enable_service nationwide.service
}
