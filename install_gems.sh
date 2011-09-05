#!/usr/bin/env bash
install_gems() {
	echo "Installing gems..."
	gem install htmlentities-4.3.0.gem 2>&1
}

install_qtbindings() {
	echo "Installing qtbindings gem..."
	gem install qtbindings-4.7.3-universal-darwin-10.gem 2>&1
}

install_gosu() {
	echo "Installing gosu gem.."
	gem install gosu-0.7.36.2-universal-darwin.gem 2>&1
}

install_gems
install_qtbindings
install_gosu
