#!/usr/bin/env bash
GEM_BIN=$1/ruby/bin/gem
export GEM_HOME=/usr/local/kidsruby/ruby/lib/ruby/gems/1.9.1

install_gems() {
	echo $KIDSRUBY_INSTALLING_GEMS
  ${GEM_BIN} install htmlentities-4.3.0.gem --no-ri --no-rdoc 2>&1
  ${GEM_BIN} install rubywarrior-i18n-0.0.3.gem --no-ri --no-rdoc 2>&1
  ${GEM_BIN} install serialport-1.1.1-universal.x86_64-darwin-10.gem --no-ri --no-rdoc 2>&1
  ${GEM_BIN} install hybridgroup-sphero-1.0.1.gem --no-ri --no-rdoc 2>&1
}

install_qtbindings() {
	echo $KIDSRUBY_INSTALLING_QTBINDINGS
	${GEM_BIN} install qtbindings-4.7.3-universal-darwin-10.gem --no-ri --no-rdoc 2>&1
}

install_gosu() {
	echo $KIDSRUBY_INSTALLING_GOSU
	${GEM_BIN} install gosu-0.7.36.2-universal-darwin.gem --no-ri --no-rdoc 2>&1
}

install_gems
install_qtbindings
install_gosu
