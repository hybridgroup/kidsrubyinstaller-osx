#!/bin/bash

# 
# ----------------------------------------------------------------
# 
# DESCRIPTION:
# 
# A Script that assigns an icon to a file or a folder
# 
# (c) Ali Rantakari, 2007
#     http://hasseg.org
#     fromassigniconscript.20.hasseg@spamgourmet.com
# 
# ----------------------------------------------------------------
# 
# REQUIRES:
# 
# - OS X 10.4 (Tiger) or later
# - Developer Tools installed (found on OS discs)
# 
# ----------------------------------------------------------------
# 
# Thanks to "KenFerry" for posting instructions on how to do
# this at cocoadev.com:
# 
# http://www.cocoadev.com/index.pl?HowToSetACustomIconWithRez
# 
# 







# ----------------------------------------------------------------
# 
# SETTINGS:
# 
# 


# locations of CLI apps used
# 
# system:
#
FILE=/usr/bin/file
OSASCRIPT=/usr/bin/osascript
# 
# installed with developer tools:
# 
SETFILE=/Developer/Tools/SetFile
REZ=/usr/bin/Rez



# - - - - - - - - - - - - - - - - - - - - - -
# settings end here.
# ----------------------------------------------------------------
# 














# Script IMPLEMENTATION begins here ---------------------------
# -------------------------------------------------------------
# 



# see if parameters are set
if [ -n "$1" ] || [ -n "$2" ];then
	
	echo " "
	
	# determine if second parameter is a file or a folder
	if [ "`$FILE -b \"$2\"`" == "directory" ];then
		
		echo "Assigning icon to folder \"$2\"..."
		
		echo "read 'icns' (-16455) \"$1\";" | $REZ -o "`printf "$2/Icon\r"`"
		
	else
		
		echo "Assigning icon to file \"$2\"..."
		
		echo "read 'icns' (-16455) \"$1\";" | $REZ -o "$2"
		
	fi
	
	$SETFILE -a "C" "$2"
	
	echo "...done"
	echo " "
	
	if [ "$3" != "-r" ];then
		echo "Telling Finder to refresh the item..."
		
		TARGETSPATH=`dirname $2`
		TARGETSFULLPATH="`cd $TARGETSPATH; pwd`/$2"
		
		$OSASCRIPT -e "tell application \"Finder\" to update POSIX file \"$TARGETSFULLPATH\""
		echo "...done"
		echo " "
	fi
	
else

	echo " "
	echo "usage: `basename \"$0\"` <iconfile> <target> -r"
	echo " "
	echo " <iconfile>  is the .icns icon you want to assign"
	echo " <target>    is the file or folder you want to"
	echo "             assign the icon to"
	echo " "
	echo " -r   if this option is set, Finder will not be"
	echo "      told to update the target"
	echo " "
	
fi
