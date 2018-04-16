#!/usr/bin/env tclsh 

package require Tk

# find our libraries in ../lib  ???
lappend auto_path [file join [file dirname [info script]] "../lib/example" ]

package require example 1.0

# A simple view that executes a command and logs the output
# TODO: make sure we don't pass empty commands. Empty args are ok.

proc view {} {
    frame .logview
    pack .logview -fill x
    text .logview.main -relief flat -bd 2 -yscrollcommand ".logview.scroll set"
    scrollbar .logview.scroll -command ".logview.main yview"
    pack .logview.main -side left -fill y
    pack .logview.scroll -side right -fill y
    frame .run -borderwidth 5
    pack .run -fill x
    button .run.btn -text "run" -command execute 
    entry .run.cmd -textvar cmdVal
    entry .run.arg -textvar argVal
    pack .run.btn -side right -padx 10
    pack .run.cmd -side left
    pack .run.arg -side left -padx 5
}

proc execute {} {
    global argVal cmdVal
    set f [open "| $cmdVal $argVal" r]
    while {[gets $f x] >= 0} {
        .logview.main insert 1.0 "$x\n"
    }
}
view
