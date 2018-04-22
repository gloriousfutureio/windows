package provide workouts 1.0

package require sqlite3

proc workout {w} {
    # This would work, but it's not nice:
    # lappend ::workouts::tempAlias $w
    ::workouts::addCommand $w
    interp alias {} $w {} ::workouts
    return
}


namespace eval ::workouts {

    # Pass empty braces to initialize 
    variable tempAlias {}
    variable val 1

    # We will treat data as a list of dict
    variable data {}
    variable workoutMeta {}

    namespace export initDb help commit curls
    namespace export debug 
    namespace ensemble create

    proc curls {reps lbs args} {
        variable data
        if {[llength args] > 1} {
            set usage "provide either 2 or 3 arguments (curls {reps lbs args})"
            error $usage
        }

        # create a dictonary from our args
        set d [dict create name curls weight_lbs $lbs reps $reps]

        # append our dictionary values
        lappend data $d
    }

    proc commit {} {
        variable tempAlias
        variable data

        # remove the symbol passed to workout from interpreter
        interp alias {} [lindex $tempAlias 0] {}

        # empty our namespace data
        set data {}
        set tempAlias {}
    }

    proc debug {} {
        variable tempAlias
        variable data
        foreach cmd $tempAlias {
            puts "registered: $cmd"
        }
        puts "data:"
        puts [set data]
    }

    proc addCommand cmd {
        variable tempAlias
        set l [llength $tempAlias]
        if {$l > 0} {
            set msg "commit or delete existing workouts before creating new ones"
            error $msg
        }
        lappend tempAlias $cmd
    }

    proc help {} {
        puts "package workouts"
        puts "Utility to log workouts in a database"
        puts "Usage: "
        puts "workout w         # w is a new workout"
        puts "w curls 6 25      # 6 reps 25 lbs"
        puts "w curls 6 25      # another 6 reps 25 lbs"
        puts "w press 10 35 3   # specify multiple sets: 10 reps, 35 lb, 3 sets"
        puts "w commit          # add to database"
    }

    proc initDb path {
        sqlite db $path
        db eval {
            CREATE TABLE IF NOT EXISTS workouts (
                id INTEGER PRIMARY KEY,
                start DATETIME,
                end DATETIME
            )
        }
        db eval {
            CREATE TABLE IF NOT EXISTS exercises (
                id INTEGER PRIMARY KEY,
                name TEXT,
                weight_lbs NUMERIC,
                reps NUMERIC,
                duration_sec NUMERIC,
            )
        }
        db close
    }


}

