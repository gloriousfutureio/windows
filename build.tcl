#!/usr/bin/env tclsh

# Build our package index files, etc.

proc Libraries {libs} {
    foreach lib $libs {
        UpdateIndex [file join "lib/$lib"]
    }
}

proc UpdateIndex {dir} {
    # From: Practical Progamming in Tcl and TK; Welch, Jones, Hobbs (2003)
    set index [file join $dir pkgIndex.tcl]
    if {![file exists $index]} {
        set doit 1
    } else {
        set age [file mtime $index]
        set doit 0
        # The directory's timestamp changes if files were deleted.
        if {[file mtime $dir] > $age} {
            set doit 1
        } else {
            foreach f [glob [file join $dir *.tcl]] {
                if {[file mtime $f] > $age} {
                    set doit 1
                    break
                }
            }
        }
    }
    if { $doit } {
        # Rebuild the tclIndex 
        pkg_mkIndex $dir *.tcl
    }
}

# Call our proc.
Libraries {
    example
}

