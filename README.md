# apple-core

Apple's BSD command line tools, built as a single coherent package — the
Darwin counterpart to GNU coreutils.

The sources are Apple's own open-source userland (`file_cmds`, `text_cmds`,
`shell_cmds`, `system_cmds`, `diskdev_cmds`, `network_cmds`, …), carried as
submodules under `src/`. What this project adds is a build system: Apple ships
these as a scattering of Xcode projects that expect the internal SDK, and
apple-core replaces that with one `bmake` tree that builds against the public
SDK on a stock macOS install.

A handful of tools missing from Apple's set are vendored from FreeBSD in
`src/bsd_additions/` (`factor`, `indent`, `ee`, `timeout`).

## Building

Requires Xcode (or the Command Line Tools) and `bmake`.

```bash
git clone --recurse-submodules https://github.com/xnuports/apple-core.git
cd apple-core && bmake
```

Binaries land in `build/release/`, laid out the way stock macOS installs them:

```
build/release/{bin,sbin,usr/bin,usr/sbin,usr/libexec}
```

Useful targets:

```bash
bmake              # build everything in the default set
bmake list-progs   # print the inventory with install locations
bmake clean        # remove build/
```

### Optional tiers

The default build is the strict coreutils-like set. Three groups are gated
off, each enabled independently:

```bash
bmake MK_DIAGNOSTICS=yes        # fs_usage, latency, zprint, vm_stat, gcore, …
bmake MK_DAEMONS=yes            # telnetd, tftpd, rtadvd, getty, …
bmake MK_PRIVATE_FRAMEWORKS=yes # tools needing FSKit/APFS/kextmanager
```

Current state: the default set builds clean — **226 of 226**, no errors. With
all three tiers on, 247 of 265 build; the remaining 18 are diagnostics and
daemons that need headers or Mach routines the public SDK does not ship
(`kdebug.h`, `libproc_private.h`, `stack_logging.h`, `task_read_for_pid()`, …).

A few build with caveats rather than as exact ports, each documented in its
own `mk/tool.d/<tool>.mk`: `timeout` cannot follow descendants past its direct
child (Darwin has no subreaper API), the FSKit-backed tools report FSKit as
unavailable — Apple's own fallback for that case, `ifconfig`'s two newer
netem model values are recovered from the shipped binary rather than any
published header, and `tiffutil -info` differs cosmetically from the stock
binary's because we link the installed libtiff rather than a patched one
(`-dump` is byte-identical).

## Layout

| Path | |
|---|---|
| `src/` | tool sources (submodules) |
| `lib/` | static libraries built from source (`libutil`, `libtelnet`, `libxo`, `libmd`) |
| `include/` | private headers vendored where the SDK ships none |
| `frameworks/` | private framework headers, reached with `-F` |
| `mk/` | the build system — `progs.mk` inventory, `tool.mk` engine, `tool.d/` per-tool fragments |
| `tools/` | helper scripts |

To add or adjust a tool, edit its `mk/tool.d/<tool>.mk`; the inventory itself
lives in `mk/progs.mk`.

## Licensing

Apple's sources are APSL-2.0 and BSD; the FreeBSD additions are BSD; a few
files are MIT. `LICENSE` collects the full texts, with per-license copies in
`LICENSE.APSL-2.0`, `LICENSE.BSD-2`, `LICENSE.BSD-3` and `LICENSE.MIT`.

Submodules under `src/` and `lib/` keep their own upstream licences.
