# apple-core

Apple's BSD command line tools, built as a single coherent package — the
Darwin counterpart to GNU coreutils.

The sources are Apple's own open-source userland (`file_cmds`, `text_cmds`,
`shell_cmds`, `system_cmds`, `diskdev_cmds`, `network_cmds`, …) and the
libraries it links (`libutil`, `libmd`, `libtelnet`, …), carried as submodules
under `src/` that track apple-oss-distributions directly. What this project
adds is a build system: Apple ships these as a scattering of Xcode projects
that expect the internal SDK, and apple-core replaces that with one `bmake`
tree that builds against the public SDK on a stock macOS install.

A handful of tools missing from Apple's set are vendored from FreeBSD in
`src/bsd_additions/` (`factor`, `indent`, `ee`, `timeout`).

## Building

Requires Xcode (or the Command Line Tools) and `bmake`.

```bash
git clone --recurse-submodules https://github.com/xnuports/apple-core.git
cd apple-core && bmake && bmake check
```

Everything lands in `build/release/`, laid out as the root of a stock macOS
install — `bin`, `sbin`, `usr/bin`, `usr/sbin`, `usr/libexec`, `usr/lib` —
with each file where macOS keeps its own copy. There is no `install` target:
the release tree is the product.

Useful targets:

```bash
bmake              # libraries, then ports (if enabled), then programs
bmake check        # every inventory entry produced its files; nothing stale
bmake list-progs   # the program inventory with install locations
bmake list-libs    # the library inventory
bmake list-ports   # the port inventory
bmake clean        # remove build/, keeping the ports work directories
bmake clean-ports  # remove the ports work directories
bmake distclean    # remove build/ entirely
```

Run `bmake check` after any build you care about. One entry failing does not
stop the rest, so without it a broken tool simply goes missing from the
release tree.

### Optional tiers

The default build is the strict coreutils-like set. Four groups are gated
off, each enabled independently:

```bash
bmake MK_DIAGNOSTICS=yes        # fs_usage, latency, zprint, vm_stat, gcore, …
bmake MK_DAEMONS=yes            # telnetd, tftpd, rtadvd, getty, …
bmake MK_PRIVATE_FRAMEWORKS=yes # tools needing FSKit/APFS/kextmanager
bmake MK_PORTS=yes              # zsh, tcsh, uucp, lsof, xar, pcre: their own build systems
```

## State

The default set builds clean: **all 261 programs** and **all 21
libraries**, eight of them also installed as dylibs under Apple's names
(`libutil`, `libz`, `libbz2`, `libmd`, `libtidy`, `libipsec`, and
`libcopyfile` and `libremovefile` in `usr/lib/system`). With `MK_PORTS=yes`,
**zsh** (with its `pcre` module), **tcsh** (with `csh`), **uucp**, **lsof**,
**xar**, **pcre** and **ncurses** (`clear`, `infocmp`, `tic`, `toe`, `tput`,
`tset`, linked against the system's `libncurses.5.4` as stock macOS's are)
build through their own build systems too. No entry is left unbuilt.

Where no header is published at all, what the build needs is recovered from
Apple's shipped binaries and says so where it lives: the quarantine SPI;
libxpc's pipe, entitlement and `os_transaction` SPI (`xpc/private.h`,
`os/transaction_private.h`); Network's `network/conninfo.h`; the kext
tools' SystemPolicy, KextAudit, CFXPCBridge, launchd, Bom, EFILogin,
CoreStorage and MediaKit pieces; APFS's purgeable-file, boot-info and
snapshot fsctls and volume roles (for `libbless`); `KernelManagementClient`;
and the ifconfig netem models.

The three program tiers add 39 entries, of which 20 build. The rest are
diagnostics and daemons needing headers or Mach routines the public SDK does
not ship (`kdebug.h`, `libproc_private.h`, `stack_logging.h`,
`task_read_for_pid()`, …). `vm_stat` joined them with system_cmds-1042.120.1,
which reads memory-tagging counters from a newer `struct vm_statistics64` than
the SDK declares.

A few build with caveats rather than as exact ports, each documented in its
own `mk/tool.d/<tool>.mk`: `timeout` cannot follow descendants past its direct
child (Darwin has no subreaper API), the FSKit-backed tools report FSKit as
unavailable — Apple's own fallback for that case, `ifconfig`'s two newer
netem model values are recovered from the shipped binary rather than any
published header, and `tiffutil -info` differs cosmetically from the stock
binary's because we link the installed libtiff rather than a patched one
(`-dump` is byte-identical). `libutil` carries FreeBSD's `login_cap`/`getcap`
and `sbuf` families, which Apple's does not; `su`, `login`, `newgrp`, `getty`
and `atrun` need them. `libz` is plain zlib, without Apple's vectorised
AddOn, which the drop does not wire up to the files that use it.
`kextcache`'s prelinked-kernel lzvn goes through libcompression's raw LZVN
coder, since Apple's static FastCompression library is not published, so it
links `libcompression` where stock links `libkxld`. `libbless` leaves out
`BLSetOFLabelForDevice.c`, the one file needing MediaKit, which nothing
calls.

## Build system

`bmake`, with two engines driven by flat inventories — the same architecture
as the sibling [xcode-tools](https://github.com/xnuports/xcode-tools) project:

| | |
|---|---|
| `mk/tool.mk` | compiles a program or a library from sources; driven by `mk/progs.mk` and `mk/libs.mk` |
| `mk/port.mk` | drives a component's own build system (autoconf, CMake, make); driven by `mk/ports.mk` |
| `mk/tool.d/`, `mk/port.d/` | per-entry flags |
| `mk/with-*.mk` | reusable link bundles |
| `mk/patches/<name>/` | patches to an entry's sources |
| `mk/scripts/pbxinfo.py` | prints an Apple target's sources and settings from its `.xcodeproj` |

Adding a tool is one line in `mk/progs.mk`, plus a `mk/tool.d/<tool>.mk` only
if it needs flags — sources are discovered automatically.

**Submodules are never written to.** Every Makefile lives outside them and
reaches in read-only. A source that has to change does so through a patch in
`mk/patches/<name>/`, written against the submodule root (as `git
format-patch` in the submodule produces it) and applied to a private copy
under `build/src/` or `build/ports/`.

Libraries always produce `build/lib/<name>.a`, which is what the programs
link, so the release tree runs in place. Those Apple ships as dylibs are also
linked into `build/release/usr/lib`, under Apple's install names.

## Layout

| Path | |
|---|---|
| `src/` | tool and library sources (submodules) |
| `lib/` | `libxo`, and the driver for `mk/libs.mk` |
| `ports/` | the driver for `mk/ports.mk` |
| `include/` | private headers vendored where the SDK ships none |
| `frameworks/` | private framework headers, reached with `-F` |
| `mk/` | the build system |
| `docs/` | progress notes and the submodule audit |
| `tools/` | helper scripts |

## Licensing

Apple's sources are APSL-2.0 and BSD; the FreeBSD additions are BSD; a few
files are MIT. `LICENSE` collects the full texts, with per-license copies in
`LICENSE.APSL-2.0`, `LICENSE.BSD-2`, `LICENSE.BSD-3` and `LICENSE.MIT`.

Submodules under `src/` and `lib/` keep their own upstream licences.
