package provide workouts 1.0

package require sqlite3

proc workout {w} {
    ::workouts::addCommand $w
    interp alias {} $w {} ::workouts
    return
}


namespace eval ::workouts {

    # Pass empty braces to initialize 
    variable tempAlias {}
    variable val 1

    # We will treat data as a list of dict (list of exercises)
    variable data {}
    variable workoutMeta {}

    namespace export initDb help commit curls start finish band squats pushups
    namespace export debug 
    namespace ensemble create

    proc minargs {msg num args} {
        if {[llength args] >= $num} {
            error $msg
        }
    }

    proc curls {reps lbs args} {
        variable data
        # create a dictonary from our args
        set d [dict create name curls weight_lbs $lbs reps $reps]
        lappend data $d
    }

    proc band {type reps} {
        #variable data
        set valid [list frontraise curls flys rows]
        if {[lsearch -exact $valid $type] == -1} {
            error "valid band types: $valid"
        }
        #set d [dict create name "bands_$type" reps $reps]
        #lappend data $d
        repExercise "bands_$type" $reps
    }

    proc repExercise {name reps} {
        variable data
        set d [dict create name $name reps $reps]
        lappend data $d
    }

    proc pushups {reps} {
        repExercise pushups $reps
    }

    proc squats {reps} {
        repExercise squats $reps
    }


    # If we are entering in a workout from the gym later, only the end time
    # will be set. But if we are doing a working in our home, we can call start
    # to set the start time.

    proc start {} {
        variable workoutMeta
        dict set workoutMeta start [clock seconds]
    }

    proc finish {} {
        variable workoutMeta
        dict set workoutMeta end [clock seconds]
    }

    proc commit {} {
        variable tempAlias
        variable data

        # remove the symbol passed to workout from interpreter
        interp alias {} [lindex $tempAlias 0] {}

        # commit to db
        sqlite db "~/.config/workouts.db"
        db nullvalue NULL
        initDb db

        # Create a new workout
        set defaultCols [dict create start NULL end NULL]

        set now [clock seconds]
        set defaultCols [
           dict create name NULL weight_lbs NULL reps NULL duration NULL created $now
        ]  

        foreach {item} $data { 
            # with duplicate keys, merge takes the latter dictionaries passed
            set record [dict merge $defaultCols $item]
            dict with record {
                db eval {
                    INSERT INTO exercises (name, weight_lbs, reps, duration_sec, created) 
                        VALUES ($name, $weight_lbs, $reps, $duration, datetime('$created', 'unix', 'utc'))
                }
            }
        }
        db close

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

    proc initDb db {
        # no trailing commas allowed
        db eval {
            CREATE TABLE IF NOT EXISTS workouts (
                id INTEGER PRIMARY KEY,
                start DATETIME,
                end DATETIME,
                created DATETIME
            )
        }
        db eval {
            CREATE TABLE IF NOT EXISTS exercises (
                id INTEGER PRIMARY KEY,
                name TEXT,
                weight_lbs NUMERIC,
                reps NUMERIC,
                duration_sec NUMERIC,
                created DATETIME
            )
        }
    }

}

