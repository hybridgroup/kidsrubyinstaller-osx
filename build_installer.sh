#!/bin/sh
cleanup() {
	if [ -d "build/KidsRuby.app" ]
	then
		rm -r "build/KidsRuby.app"
	fi
	if [ -d "resources/KidsRuby.app" ]
	then
		rm -r "resources/KidsRuby.app"
	fi
	if [ -d "build/KidsRubyInstaller.app" ]
	then
		rm -r "build/KidsRubyInstaller.app"
	fi
}

build_launcher() {
	cd build
	../appify.sh ../kidsruby.sh "KidsRuby"
	cd ..
	mv build/KidsRuby.app resources
}

copy_irb() {
	cp kidsirb.sh resources
}

build_installer() {
	/usr/local/bin/platypus -AR  -l -i '/Applications/Platypus.app/Contents/Resources/PlatypusDefault.icns' -a 'KidsRuby Installer for OSX' -o 'Progress Bar' -p '/bin/sh' -u 'The Hybrid Group + Friends'  -V '0.6'  -I 'org.kidsruby.installer' -f '/Users/ron/Developer/kidsrubyinstaller-osx/resources/git-1.7.6-i386-snow-leopard.dmg' -f '/Users/ron/Developer/kidsrubyinstaller-osx/resources/ruby-1.9.2-p290.universal.tar.gz' -f '/Users/ron/Developer/kidsrubyinstaller-osx/resources/yaml-0.1.4.universal.tar.gz' -f '/Users/ron/Developer/kidsrubyinstaller-osx/resources/qt-mac-opensource-4.7.3.dmg' -f '/Users/ron/Developer/kidsrubyinstaller-osx/resources/qtbindings-4.7.3-universal-darwin-10.gem' -f '/Users/ron/Developer/kidsrubyinstaller-osx/resources/kidsruby.tar.gz' -f '/Users/ron/Developer/kidsrubyinstaller-osx/resources/kidsirb.sh' -f '/Users/ron/Developer/kidsrubyinstaller-osx/resources/KidsRuby.app'  -g '#000000'  -b '#ffffff'  -c '/Users/ron/Developer/kidsrubyinstaller-osx/installer.sh' 'build/KidsRubyInstaller.app'
}

cleanup
build_launcher
copy_irb
build_installer
