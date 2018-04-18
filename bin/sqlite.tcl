#!/usr/bin/env tclsh
#
#
package require sqlite3
lappend auto_path [file join [file dirname [info script]] "../lib/workouts" ]

package require workouts

# Give us a db object for the example.db file
#sqlite3 db example.db


#set x [db eval {SELECT * FROM t1 ORDER BY a}]

#db eval {SELECT * FROM t1 ORDER BY a} values {
#    parray values
#    puts ""
#}

