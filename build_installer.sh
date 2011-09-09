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
	../assignIcon.py ../kidsrubylogo.png KidsRuby.app
	tar cvzf "KidsRuby.app.tar.gz" KidsRuby.app
	cd ..
	mv build/KidsRuby.app.tar.gz resources
}

copy_scripts() {
	cp install_gems.sh resources
	cp kidsirb.sh resources
}

build_installer() {
	/usr/local/bin/platypus -AR  -l -i 'kidsruby.icns' -a 'KidsRuby Installer for OSX' -o 'Progress Bar' -p '/bin/sh' -u 'The Hybrid Group + Friends'  -V '0.6.1'  -I 'org.kidsruby.installer' -f 'resources/git-1.7.6-i386-snow-leopard.dmg' -f 'resources/ruby-1.9.2-p290.universal.tar.gz' -f 'resources/yaml-0.1.4.universal.tar.gz' -f 'resources/qt-mac-opensource-4.7.3.dmg' -f 'resources/qtbindings-4.7.3-universal-darwin-10.gem' -f 'resources/kidsruby.tar.gz' -f 'resources/kidsirb.sh' -f 'resources/KidsRuby.app.tar.gz' -f "resources/gosu-0.7.36.2-universal-darwin.gem" -f "resources/htmlentities-4.3.0.gem" -f "resources/install_gems.sh" -g '#000000'  -b '#ffffff'  -c 'installer.sh' 'build/KidsRubyInstaller.app'
}

build_dmg() {
	cd build
	../makedmg KidsRubyInstaller.app
	cd ..
}

cleanup
build_launcher
copy_scripts
build_installer
build_dmg
