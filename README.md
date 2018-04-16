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

Our build script can do this for us.

## Interactive commands

Try these fascinating commands at the `tclsh` command line

```
info tclversion
info commands
```

## Nicer shell

The default `tclsh` and `wish` are super stripped down, and don't even provide
command history. To achive this, clone and compile `rlwrap`, and invoke
like `rlwrap tclsh`



