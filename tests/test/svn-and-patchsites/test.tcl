package require tcltest 2
namespace import tcltest::*

source [file dirname $argv0]/../library.tcl
set path [file dirname [file normalize $argv0]]

initial_setup

proc svn-patch {} {
    global output_file path

    set svn "error*"
    set line [get_line $path/$output_file $svn]
    if {$line == -1} {
        return "No error found."
    } else {
        set ret "Errors found in output file:\n"
        append ret [exec cat $path/$output_file]
        return $ret
    }
}

test svn-patchsites {
    Regression test for svn-and-patchsites.
} -constraints {
    has_svn
} -body {
    svn-patch
} -result "No error found."


cleanup
cleanupTests
