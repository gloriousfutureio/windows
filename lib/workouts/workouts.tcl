package provide workouts 1.0

package require sqlite3


namespace eval ::workouts {

    namespace export initDb

    proc initDb path {
        sqlite db $path
        db eval {
            CREATE TABLE IF NOT EXISTS workouts (
                id BINARY,
                start DATETIME,
                end DATETIME
            )
        }
        db eval {
            CREATE TABLE IF NOT EXISTS exercises (
                id BINARY,
                name TEXT,
                weight_lbs NUMERIC,
                duration_sec NUMERIC,
            )
        }
    }

}

