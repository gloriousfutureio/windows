#!/usr/bin/env tclsh 

package require Tk

puts [file join [file dirname [info script]] "../lib/example" ]

# find our libraries in ../lib  ???
lappend auto_path [file join [file dirname [info script]] "../lib/example" ]

package require example 1.0

# A simple view that executes a command and logs the output
# TODO: make sure we don't pass empty commands. Empty args are ok.

proc view {} {
    menu .mbar

    . config -menu .mbar
    .mbar add cascade -label "System" -underline 0 \
        -menu [menu .mbar.system -tearoff 0]

    frame .logview
    # set up menu
    #.mbar add checkbutton -label "OK" -command { puts "OK" }



    pack .logview -fill x
    text .logview.main -relief flat -bd 2 -bg black -yscrollcommand ".logview.scroll set"
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
    frame .modes  -borderwidth 5
    button .modes.ok -text "OK" -command { puts "button ok" }
    pack .modes.ok -side left
}

proc execute {} {
    global argVal cmdVal
    set f [open "| $cmdVal $argVal" r]
    while {[gets $f x] >= 0} {
        .logview.main insert 1.0 "$x\n"
    }
}
view
#proc print_hierarchy {w {depth 0}} {
#    puts "[string repeat "  " $depth][winfo class $w] w=[winfo width $w] h=[winfo height $w] x=[winfo x $w] y=[winfo y $w]"
#    foreach i [winfo children $w] {
#        print_hierarchy $i [expr {$depth+1}]
#    }
#}
#print_hierarchy .
