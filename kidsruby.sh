#!/bin/sh
export PATH=/usr/local/kidsruby/ruby/bin:$PATH
export DYLD_LIBRARY_PATH=/usr/local/kidsruby/lib:$DYLD_LIBRARY_PATH
export GEM_HOME=/usr/local/kidsruby/ruby/lib/ruby/gems/1.9.1
export GEM_PATH=/usr/local/kidsruby/ruby/lib/ruby/gems/1.9.1
ruby /Applications/KidsRuby/kidsruby/main.rb
