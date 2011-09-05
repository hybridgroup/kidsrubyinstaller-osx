#!/bin/sh
INSTALLDIR="/Applications/KidsRuby"
CODEDIR="/usr/local/kidsruby"

# determine OSX version
TIGER=4
LEOPARD=5
SNOW_LEOPARD=6
LION=7
osx_version=$(sw_vers -productVersion | awk 'BEGIN {FS="."}{print $2}')
if [ $osx_version -eq $LEOPARD -o $osx_version -eq $SNOW_LEOPARD -o $osx_version -eq $LION ]; then
	echo "Starting KidsRuby install..."
else
	echo "Sorry, KidsRuby is not currently supported on your operating system."
	exit
fi

create_install_dir() {
	echo "Creating installation directory..."
	if [ ! -d "$INSTALLDIR" ]
	then
		mkdir "$INSTALLDIR"
	fi
	echo "Creating code directory..."
	if [ ! -d "$CODEDIR" ]
	then
		mkdir "$CODEDIR"
	fi
	chmod -R a+rw "$CODEDIR"
}

install_qt() {
	echo "Installing Qt..."
	hdiutil attach qt-mac-opensource-4.7.3.dmg
	/usr/sbin/installer -verbose -pkg "/Volumes/Qt 4.7.3/Qt.mpkg" -target /
	hdiutil detach "/Volumes/Qt 4.7.3"
}

install_git() {
	echo "Installing git..."
	hdiutil attach git-1.7.6-i386-snow-leopard.dmg
	/usr/sbin/installer -verbose -pkg "/Volumes/Git 1.7.6 i386 Snow Leopard/git-1.7.6-i386-snow-leopard.pkg" -target /
	hdiutil detach "/Volumes/Git 1.7.6 i386 Snow Leopard"
}

install_ruby() {
	echo "Installing Ruby 1.9.2..."
	tar -xvzf ruby-1.9.2-p290.universal.tar.gz -C "$CODEDIR"
	export PATH="$CODEDIR/ruby/bin:$PATH"
	chmod -R a+r "$CODEDIR"
}

install_kidsruby() {
	echo "Installing kidsruby editor..."
	tar -xvzf kidsruby.tar.gz -C "$INSTALLDIR"
}

install_commands() {
	echo "Installing commands..."
	tar -xvzf KidsRuby.app.tar.gz -C "$INSTALLDIR"
	cp kidsirb.sh "$INSTALLDIR"
}

create_install_dir
install_qt
install_git
# # install libyaml here?
install_ruby
./install_gems.sh 2>&1
install_kidsruby
install_commands

echo "KidsRuby installation complete. Have fun!"