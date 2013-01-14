#!/bin/sh
RUN_DIR="$(pwd)"
BUILD_DIR="$RUN_DIR/build"
RUBY_DIR="/usr/local/kidsruby"
RUBY_VERSION="1.9.2-p320"
SERIALPORT_VERSION="1.2.1"
QT_VERSION="4.7.3"

export "GEM_HOME=$RUBY_DIR/ruby/lib/ruby/gems/1.9.1"
export "GEM_PATH=$RUBY_DIR/ruby/lib/ruby/gems/1.9.1"

echo "Make sure you download and install the Platypus installer from here: http://www.sveinbjorn.org/platypus"
echo "Make sure you clone the hybridgroup qtbindings gem into ~/Developer/qtbindings"
echo "Make sure you clone the hybridgroup serialport gem into ~/Developer/serialport"

create_dirs() {
  if [ ! -d "build" ]
	then
		mkdir build
	fi

	if [ ! -d "resources" ]
	then
		mkdir resources
	fi

	if [ ! -d "$RUBY_DIR" ]
	then
		mkdir "$RUBY_DIR"
	fi

	if [ ! -d "$RUBY_DIR/ruby" ]
	then
		mkdir "$RUBY_DIR/ruby"
	fi
}

check_qt() {
	if [ ! -f "resources/qt-mac-opensource-$QT_VERSION.dmg" ]
	then
		curl "http://get.qt.nokia.com/qt/source/qt-mac-opensource-$QT_VERSION.dmg" > "resources/qt-mac-opensource-$QT_VERSION.dmg"
	fi
}

check_git() {
	if [ ! -f "resources/git-1.7.6-i386-snow-leopard.dmg" ]
	then
		curl "http://git-osx-installer.googlecode.com/files/git-1.7.6-i386-snow-leopard.dmg" > "resources/git-1.7.6-i386-snow-leopard.dmg"
	fi
}

get_yaml() {
	if [ ! -f "build/yaml-0.1.4.tar.gz" ]
	then
		curl "http://pyyaml.org/download/libyaml/yaml-0.1.4.tar.gz" > "build/yaml-0.1.4.tar.gz"
	fi
}

build_yaml() {
	cd build
	if [ ! -d "yaml" ]
	then
		mkdir yaml
	fi
	tar -xvzf yaml-0.1.4.tar.gz
	cd yaml-0.1.4
	CFLAGS="-arch i386 -arch x86_64"
	export CFLAGS
	LDFLAGS="-arch i386 -arch x86_64"
	export LDFLAGS
	./configure --enable-load-relative --prefix="$BUILD_DIR/yaml" --disable-dependency-tracking
	make
	make install
	cd ../..
	tar cvzf resources/yaml-0.1.4.universal.tar.gz build/yaml
}

check_yaml() {
	if [ ! -f "resources/yaml-0.1.4.universal.tar.gz" ]
	then
		get_yaml
		build_yaml
	fi
}

get_ruby() {
	if [ ! -f "build/ruby-$RUBY_VERSION.tar.gz" ]
	then
		curl "http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-$RUBY_VERSION.tar.gz" > "build/ruby-$RUBY_VERSION.tar.gz"
	fi
}

build_ruby() {
	echo "Building Ruby $RUBY_VERSION..."
	cd "$BUILD_DIR"
	tar -xvzf ruby-$RUBY_VERSION.tar.gz
	cd "ruby-$RUBY_VERSION"
	export C_INCLUDE_PATH=/usr/include:$C_INCLUDE_PATH
	export LIBRARY_PATH=/usr/lib:LIBRARY_PATH
	export CFLAGS="-L /usr/lib -I /usr/include -isysroot /Developer/SDKs/MacOSX10.5.sdk -mmacosx-version-min=10.5"
	export LDFLAGS=$CFLAGS
	export MACOSX_DEPLOYMENT_TARGET=10.5
	./configure --enable-load-relative --enable-shared --with-arch=i386,x86_64 --prefix="$RUBY_DIR/ruby"
	make
	make install
}

build_serialport() {
	echo "Building serialport gem..."
	export "PATH=$RUBY_DIR/ruby/bin:$PATH"
	export "GEM_HOME=$RUBY_DIR/ruby/lib/ruby/gems/1.9.1"
	export "GEM_PATH=$RUBY_DIR/ruby/lib/ruby/gems/1.9.1"
	cd ~/Developer/ruby-serialport
	"$RUBY_DIR/ruby/bin/ruby" "$RUBY_DIR/ruby/bin/rake" compile
	"$RUBY_DIR/ruby/bin/ruby" "$RUBY_DIR/ruby/bin/rake" native gem
	cp pkg/hybridgroup-serialport-$SERIALPORT_VERSION-universal.x86_64-darwin-10.gem "$RUN_DIR/resources/hybridgroup-serialport-$SERIALPORT_VERSION-universal.x86_64-darwin-10.gem"
	cd "$RUN_DIR"
}

build_qtbindings() {
	echo "Building qtbindings gem..."
	export "PATH=$RUBY_DIR/ruby/bin:$PATH"
	export VERSION=$QT_VERSION
	cd ~/Developer/qtbindings
	"$RUBY_DIR/ruby/bin/ruby" "$RUBY_DIR/ruby/bin/rake" gemosx
	cp qtbindings-$QT_VERSION-universal-darwin-10.gem "$RUN_DIR/resources/qtbindings-$QT_VERSION-universal-darwin-10.gem"
	cd "$RUN_DIR"
}

compress_ruby() {
	cd "$RUBY_DIR"
	tar cvzf "$RUN_DIR/resources/ruby-$RUBY_VERSION.universal.tar.gz" ruby
	cd "$RUN_DIR"
}

check_ruby() {
	if [ ! -f "resources/ruby-$RUBY_VERSION.universal.tar.gz" ]
	then
		get_ruby
		build_ruby
		
		update_rubygems
		update_rake
		
		install_rake_compiler
		build_qtbindings
		install_qtbindings
		build_serialport
		install_serialport

		install_gosu
		install_other_gems

		compress_ruby
	fi
}

update_rubygems() {
	export "GEM_HOME=$RUBY_DIR/ruby/lib/ruby/gems/1.9.1"
	"$RUBY_DIR/ruby/bin/ruby" "$RUBY_DIR/ruby/bin/gem" update --system
}

update_rake() {
	export "GEM_HOME=$RUBY_DIR/ruby/lib/ruby/gems/1.9.1"
	"$RUBY_DIR/ruby/bin/ruby" "$RUBY_DIR/ruby/bin/gem" install rake -v 0.9.2.2 --no-ri --no-rdoc
}

install_rake_compiler() {
	export "PATH=$RUBY_DIR/ruby/bin:$PATH"
	export "GEM_HOME=$RUBY_DIR/ruby/lib/ruby/gems/1.9.1"
	"$RUBY_DIR/ruby/bin/ruby" "$RUBY_DIR/ruby/bin/gem" install rake-compiler --no-ri --no-rdoc
	"$RUBY_DIR/ruby/bin/ruby" "$RUBY_DIR/ruby/bin/gem" install jeweler --no-ri --no-rdoc
}

get_kidsruby() {
	/usr/local/bin/git clone --branch release git://github.com/hybridgroup/kidsruby.git
}

build_kidsruby() {
	tar cvzf "../resources/kidsruby.tar.gz" kidsruby
}

clean_kidsruby() {
  rm -rf "$BUILD_DIR/kidsruby"
  rm "resources/kidsruby.tar.gz"
}

check_kidsruby() {
	if [ ! -f "resources/kidsruby.tar.gz" ]
	then
		cd "$BUILD_DIR"
		get_kidsruby
		build_kidsruby
		cd ..
	fi	
}

install_qtbindings() {
	echo "Installing qtbindings..."
	"$RUBY_DIR/ruby/bin/ruby" "$RUBY_DIR/ruby/bin/gem" install "$RUN_DIR/resources/qtbindings-$QT_VERSION-universal-darwin-10.gem" --no-ri --no-rdoc
}

install_serialport() {
	echo "Installing serialport..."
	"$RUBY_DIR/ruby/bin/ruby" "$RUBY_DIR/ruby/bin/gem" install "$RUN_DIR/resources/hybridgroup-serialport-$SERIALPORT_VERSION-universal.x86_64-darwin-10.gem" --no-ri --no-rdoc
}

install_gosu() {
	echo "Installing gosu..."
	"$RUBY_DIR/ruby/bin/ruby" "$RUBY_DIR/ruby/bin/gem" install "$RUN_DIR/resources/gosu-0.7.36.2-universal-darwin.gem" --no-ri --no-rdoc
}

install_other_gems() {
	echo "Installing other gems..."
  "$RUBY_DIR/ruby/bin/ruby" "$RUBY_DIR/ruby/bin/gem" install htmlentities --no-ri --no-rdoc
  "$RUBY_DIR/ruby/bin/ruby" "$RUBY_DIR/ruby/bin/gem" install rubywarrior-i18n --no-ri --no-rdoc
  "$RUBY_DIR/ruby/bin/ruby" "$RUBY_DIR/ruby/bin/gem" install hybridgroup-sphero --no-ri --no-rdoc
}

create_dirs
check_qt
check_git
check_yaml
check_ruby

clean_kidsruby
check_kidsruby
