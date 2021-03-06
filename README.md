# windows

Tcl/Tk experiments.

## Conventions

Put program entrypoint scripts in **bin** and supporting code in **lib**. Any
program in bin can inlude the following line to locate libraries in lib.

```tcl
lappend auto_path \
    [file join [file dirname [info script]] ../lib/foolib]
```

`auto_path` is a global runtime variable, a list of directories. Each is 
recursively searched for Tcl packages.

Packages in lib must include a `package provide` line

```tcl
package provide foo 2.1
```

Two scripts can implement the same package if they provide the same package name
and version.

A package or script can declare a dependency on another package with `require`.

```tcl
package require foo 2.1 
```

Unfortunately, existing on the `auto_path` is not enough for packages to be 
found by require. A **pkgIndex.tcl** file must be built by running a special
indexing command in Tcl.

```tcl
pkg_mkIndex /some/lib *.tcl
```

Our build script ~~can do this for us~~ is broken, so we must write pkgIndex.tcl
files by hand for each custom library.

## Interactive commands

Try these fascinating commands at the `tclsh` command line

```
info tclversion
info commands
```

## Nicer shell

The default `tclsh` and `wish` are super stripped down, and don't even provide
command history. To become a cool person, install `tclreadline`, and 
add the following to `~/.tclshrc`

```tcl
package require tclreadline

proc ::tclreadline::prompt1 {} {
    return "[lindex [split [info hostname] "."] 0] [lindex [split [pwd] "/"] end] % "
}

::tclreadline::Loop
```


## Getting more sweet packages

You will probably need to use your system package manager. On Arch, search
the official repositories like

```
pacman -Ss sqlite | grep tcl
```

## Misc

* [some info on dictionaries](https://stackoverflow.com/questions/25814950/create-list-of-dicts-within-a-dict-in-tcl) 

