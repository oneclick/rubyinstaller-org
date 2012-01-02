require "isolate/now"

libdir = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)
require "website"

run Website
