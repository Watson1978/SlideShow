#!/bin/bash

cd ext/slideshow
ruby extconf.rb
make
cp cocoa.bundle ../../lib