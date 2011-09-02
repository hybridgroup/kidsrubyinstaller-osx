#!/bin/sh
INSTALLDIR="/Applications/KidsRuby"

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
	tar -xvzf ruby-1.9.2-p290.universal.tar.gz -C "$INSTALLDIR"
	export PATH="$INSTALLDIR/ruby/bin:$PATH"
}

install_kidsruby() {
	echo "Installing kidsruby editor..."
	cd "$INSTALLDIR"
	/usr/local/bin/git clone --branch release git://github.com/hybridgroup/kidsruby.git
}

install_bundler() {
	echo "Installing bundler..."
	gem install bundler
}

install_qtbindings() {
	echo "Installing qtbindings..."
	gem install qtbindings-4.7.3-universal-darwin-10.gem
}

create_install_dir
install_qt
install_git
# install libyaml here?
install_ruby
install_bundler
install_qtbindings
install_kidsruby

echo "KidsRuby installation complete. Have fun!"