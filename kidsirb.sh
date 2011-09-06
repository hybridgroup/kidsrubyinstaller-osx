#!/bin/sh
export PATH=/usr/local/kidsruby/ruby/bin:$PATH
export DYLD_LIBRARY_PATH=/usr/local/kidsruby/lib:$DYLD_LIBRARY_PATH
cd kidsruby
irb
cd ..
