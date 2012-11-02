#!/bin/sh
RUN_DIR="$(pwd)"
BUILD_DIR="$RUN_DIR/build"
RUBY_DIR="/usr/local/kidsruby"
export GEM_HOME=/usr/local/kidsruby/ruby/lib/ruby/gems/1.9.1

echo "Make sure your download and install the Platypus installer from here: http://www.sveinbjorn.org/platypus"

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
	if [ ! -f "resources/qt-mac-opensource-4.7.3.dmg" ]
	then
		curl "http://get.qt.nokia.com/qt/source/qt-mac-opensource-4.7.3.dmg" > "resources/qt-mac-opensource-4.7.3.dmg"
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
	./configure --prefix="$BUILD_DIR/yaml" --disable-dependency-tracking
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
	if [ ! -f "build/ruby-1.9.2-p290.tar.gz" ]
	then
		curl "http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.2-p290.tar.gz" > "build/ruby-1.9.2-p290.tar.gz"
	fi
}

build_ruby() {
	cd "$BUILD_DIR"
	tar -xvzf ruby-1.9.2-p290.tar.gz
	cd ruby-1.9.2-p290
	export CFLAGS="-isysroot /Developer/SDKs/MacOSX10.5.sdk -mmacosx-version-min=10.5"
	export LDFLAGS=$CFLAGS
	export MACOSX_DEPLOYMENT_TARGET=10.5
	./configure --enable-shared --with-arch=i386,x86_64 --prefix="$RUBY_DIR/ruby"
	make
	make install
}

build_serialport() {
	cd ~/Developer/ruby-serialport
	/usr/local/kidsruby/ruby/lib/ruby/gems/gems/rake-0.9.2.2/bin/rake compile
	/usr/local/kidsruby/ruby/lib/ruby/gems/gems/rake-0.9.2.2/bin/rake native gem
}

compress_ruby() {
	cd "$RUBY_DIR"
	tar cvzf "$RUN_DIR/resources/ruby-1.9.2-p290.universal.tar.gz" ruby
	cd "$RUN_DIR"
}

check_ruby() {
	if [ ! -f "resources/ruby-1.9.2-p290.universal.tar.gz" ]
	then
		get_ruby
		build_ruby
		compress_ruby
	fi
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

create_dirs
check_qt
check_git
check_yaml
check_ruby
clean_kidsruby
check_kidsruby

echo "You still need to build the qtbindings gem manually, and put into resources directory, before you can build the installer."
