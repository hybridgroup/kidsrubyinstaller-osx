#!/bin/sh

# determine OSX version
TIGER=4
LEOPARD=5
SNOW_LEOPARD=6
LION=7
osx_version=$(sw_vers -productVersion | awk 'BEGIN {FS="."}{print $2}')
if [ $osx_version -eq $LEOPARD -o $osx_version -eq $SNOW_LEOPARD -o $osx_version -eq $LION ]; then
	echo Supported OS
else
	echo Unsupported OS
fi

# install qt libs
hdiutil attach qt-mac-opensource-4.7.3.dmg
/usr/sbin/installer -verbose -pkg "/Volumes/Qt 4.7.3/Qt.mpkg" -target /
hdiutil detach "/Volumes/Qt 4.7.3"

# Install git

# Install ruby 1.9.2 universal binary

# create kidsruby dir

# get latest release kidsruby code from repo

# create kidsruby gemset

# install bundler

# install gems, including the fat binary of qtbindings



