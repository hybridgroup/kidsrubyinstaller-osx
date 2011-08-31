#!/bin/sh

# download/build needed resources
echo "Make sure your download and install the Platypus installer from here: http://www.sveinbjorn.org/platypus"

if [ ! -f "build" ]
then
	mkdir build
fi

if [ ! -f "resources" ]
then
	mkdir resources
fi

if [ ! -f "resources/qt-mac-opensource-4.7.3.dmg" ]
then
	curl "http://get.qt.nokia.com/qt/source/qt-mac-opensource-4.7.3.dmg" > "resources/qt-mac-opensource-4.7.3.dmg"
fi

if [ ! -f "resources/ruby-1.9.2-p290.universal.tar.gz" ]
then
	if [ ! -f "build/ruby-1.9.2-p290.tar.gz" ]
	then
		curl "http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.2-p290.tar.gz" > "build/ruby-1.9.2-p290.tar.gz"
	fi
	cd build
	if [ ! -f "ruby" ]
	then
		mkdir ruby
	fi
	cd ruby
	rubydir="$(pwd)"
	cd ..
	tar -xvzf ruby-1.9.2-p290.tar.gz
	cd ruby-1.9.2-p290
	./configure --with-arch=x86_64,i386 --prefix="$rubydir"
	make
	make install
	cd ../..
	tar cvzf resources/ruby-1.9.2-p290.universal.tar.gz build/ruby
fi