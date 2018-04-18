#!/usr/bin/env tclsh


proc fromvim {} {
    set path /tmp/foo.txt
    [exec which $::env(EDITOR)] $path
    set f [open $path r]
    set out [read $f]
    puts "out is $out"
}
