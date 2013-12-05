# Fun With Symbol Versioning

This is a very simple example, intended to illustrate two things.

 * How a shared library can be built to support multiple versions of an API
   simultaneously.

 * How this powerful technique makes it possible to screw up even worse than
   before.

The idea is very simple.  Let's say you have an API function called fubar, and
other programs not under your control use it.  Now you want to change how fubar
behaves, or add some extra arguments.  How can you create one library that
exposes all of that new functionality to new programs, while still allowing old
programs to work as well?  There are three steps.

 * Create fubar\_1 for the old functionality and fubar\_2 for the new stuff.
   You can even do things like have one call the other.

 * Use some gcc \_\_asm\_\_ magic to create linker-friendly aliases for your
   human-friendly versions of fubar, and to identify one as a default.  Usually
   this default will be the most current version, so that new programs can use
   the latest greatest.

 * Use a linker map file to expose these aliases in a way that the dynamic
   loader understands.

To see how this works, we can think in terms of a "search path" for shared
library symbols.  For a given symbol "foo" we'll start by looking for a symbol
that starts with "foo@@" (note: double).  That's the default version, so
we'll use that.  Next, we'll look for anything that starts with "foo@" (note:
single) and grab the first we find.  As a last resort, applicable even to
un-versioned libraries, well just look for "foo" unadorned.  The key is that we
can do this search either at link time or load time.  If we find a specific
@-marked version at link time, we save the version in the resulting executable
and will look **only** for that version from then on.  That's how old
applications can still find "their" versions of symbols even though newer ones
exist.

The fun comes when the executable does not contain a specific symbol version.
That happens when the version of the library available at link time didn't
contain version information, even though the version available at run time
might.  In that case, we repeat the search procedure described above at run
time.  This works great if the library author did their job and made sure that
the version we'll find is the one that older programs linked against the
un-versioned older library would expect.  However, if they messed up the order
in the map file (as this code demonstrates), those older programs might end up
calling newer versions of functions than what they expected.  This can lead to
all sorts of interesting behavior, from wrong values to segfaults to code that
mostly works or seems to work until a latent error causes a crash long after
the actual culprit has departed the scene.  The same things can happen if the
library author altogether forgets to add versions to a symbol - possibly one
that's not seen directly but needed for symbols that **are** exported to behave
correctly.  The possibilities are endless.
