# nix-os161

Nix packages for the [OS/161](http://www.os161.org) toolchain.

These packages try to adhere to the [official build instructions](http://www.os161.org/resources/setup.html) as closely as possible, except for:

- Any changes needed to make things build in the first place.
- Replacing vendored packages with Nix's versions; no need to build the same thing twice!

This has some downsides, though: it means that all optional features/dependencies of the toolchain's packages are disabled. For example, `os161-gdb`'s Python integration[^1], and features that rely on `zlib` / `libiconv` (except in `os161-gcc`, which doesn't compile without zlib).

[^1]: Although you probably wouldn't want to enable that anyway, since it uses Python 2 which triggers a security warning if you try to use it in Nixpkgs.

I didn't want to touch those kinds of things because I'm not particularly familiar with GCC, GDB and GNU binutils, and it doesn't even seem like all those features are enabled in Nixpkgs (e.g., it doesn't provide any of these packages with `libiconv`, although to be fair that dependency might have just been dropped in newer versions of GCC or something - I don't know).

Credit to https://github.com/jasonbcodd/os161-homebrew (and originally, https://github.com/benesch/homebrew-os161) for the patches getting `os161-gcc` and `os161-gdb` working on macOS, as well as being a source of alternate build flags to try when things weren't working.
