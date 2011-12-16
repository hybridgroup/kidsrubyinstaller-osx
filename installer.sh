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
	if [ ! -d "$CODEDIR/lib" ]
	then
		mkdir "$CODEDIR/lib"
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
	tar -xvzf ruby-1.9.2-p290.universal.tar.gz -C "$CODEDIR"
	export PATH="$CODEDIR/ruby/bin:$PATH"
	chmod -R a+rw "$CODEDIR"
}

symlink_qtbindings() {
	export DYLD_LIBRARY_PATH=/usr/local/kidsruby/lib:$DYLD_LIBRARY_PATH
	ln -s /usr/local/kidsruby/ruby/lib/ruby/gems/1.9.1/gems/qtbindings-4.7.3-universal-darwin-10/ext/build/smoke/qtcore/libsmokeqtcore.3.dylib /usr/local/kidsruby/lib
	ln -s /usr/local/kidsruby/ruby/lib/ruby/gems/1.9.1/gems/qtbindings-4.7.3-universal-darwin-10/ext/build/smoke/qtgui/libsmokeqtgui.3.dylib /usr/local/kidsruby/lib
	ln -s /usr/local/kidsruby/ruby/lib/ruby/gems/1.9.1/gems/qtbindings-4.7.3-universal-darwin-10/ext/build/smoke/qtxml/libsmokeqtxml.3.dylib /usr/local/kidsruby/lib
	ln -s /usr/local/kidsruby/ruby/lib/ruby/gems/1.9.1/gems/qtbindings-4.7.3-universal-darwin-10/ext/build/smoke/qtopengl/libsmokeqtopengl.3.dylib /usr/local/kidsruby/lib
	ln -s /usr/local/kidsruby/ruby/lib/ruby/gems/1.9.1/gems/qtbindings-4.7.3-universal-darwin-10/ext/build/smoke/qtsql/libsmokeqtsql.3.dylib /usr/local/kidsruby/lib
	ln -s /usr/local/kidsruby/ruby/lib/ruby/gems/1.9.1/gems/qtbindings-4.7.3-universal-darwin-10/ext/build/smoke/qtnetwork/libsmokeqtnetwork.3.dylib /usr/local/kidsruby/lib
	ln -s /usr/local/kidsruby/ruby/lib/ruby/gems/1.9.1/gems/qtbindings-4.7.3-universal-darwin-10/ext/build/smoke/qtsvg/libsmokeqtsvg.3.dylib /usr/local/kidsruby/lib
	ln -s /usr/local/kidsruby/ruby/lib/ruby/gems/1.9.1/gems/qtbindings-4.7.3-universal-darwin-10/ext/build/ruby/qtruby/src/libqtruby4shared.2.dylib /usr/local/kidsruby/lib
	ln -s /usr/local/kidsruby/ruby/lib/ruby/gems/1.9.1/gems/qtbindings-4.7.3-universal-darwin-10/ext/build/smoke/smokebase/libsmokebase.3.dylib /usr/local/kidsruby/lib
	ln -s /usr/local/kidsruby/ruby/lib/ruby/gems/1.9.1/gems/qtbindings-4.7.3-universal-darwin-10/ext/build/smoke/qtwebkit/libsmokeqtwebkit.3.dylib /usr/local/kidsruby/lib
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
./install_gems.sh ${CODEDIR} 2>&1
symlink_qtbindings
install_kidsruby
install_commands

echo "KidsRuby installation complete. Have fun!"
