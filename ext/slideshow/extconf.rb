require "mkmf"

$CFLAGS << ' -g -fobjc-arc -fobjc-exceptions -Wall -ObjC'
$LDFLAGS = ' -undefined suppress -flat_namespace -framework Foundation -framework AppKit -framework Cocoa'
create_makefile("cocoa")