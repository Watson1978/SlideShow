require "mkmf"

$CFLAGS << ' -g -fobjc-arc -fobjc-exceptions -Wall -ObjC'
$LDFLAGS = ' -undefined suppress -flat_namespace -framework AppKit -framework Cocoa -framework Quartz'
create_makefile("cocoa")
