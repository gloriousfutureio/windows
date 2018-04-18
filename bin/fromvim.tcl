#!/usr/bin/env tclsh


proc fromvim {output} {
    upvar 1 $output out
    set ts [clock seconds]
    set path "/tmp/tclsh_$ts"
    exec $::env(EDITOR) $path <@ stdin >@ stdout 2>@ stderr
    set f [open $path r]
    set out [read $f]
    return $out
}
