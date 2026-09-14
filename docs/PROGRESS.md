# darwintools — Progress Log

*Last updated: 2026-08-24 (session 3) · HEAD: `61d1e44 build: compile ifconfig`*

## Milestones completed

| Date | Work | Commits / evidence |
|---|---|---|
| 2026-08-21 | Full submodule audit vs `references/bsdutils` + `references/coreutils-bsd` | `SUBMODULE_AUDIT.md` |
| 2026-08-21/22 | Removed `at_cmds` (AppleTalk legacy, unbuildable) | `cebc8c4` |
| 2026-08-21/22 | Stocked `lib/` then reduced to keepers after system-link audit | `62e9e4a`…`5b60901`, `4bcffc2`…`6694ede` |
| 2026-08-22 | System-link strategy verified against MacOSX26.5.sdk (headers + .tbd inventory, dyld shared-cache runtime proof) | audit §4 |
| 2026-08-22 | Header-only staging: `include/{apfs,ktrace,liblzma,libsysmon,libxo}` | `63bd437`, `5bb9e1f`, `52685d3`, `f3299f7`, `cb6757e` |
| 2026-08-22 | `PrivateFrameworks/` → `frameworks/` rename incl. ghost-path cleanup | `d940988`, `d695174` |
| 2026-08-22 | `xcrmint` replaces `fix-macosx-internal-sdk` | `72a3463` |
| 2026-08-22 | Reverse-engineering toolchain live (`ipsw`, silicon-* skills; tools on PATH) | session setup |
| 2026-08-22 | Licensing complete: combined `LICENSE` (now 9 sections incl. BSD-4), `LICENSE.{BSD-2,BSD-3,MIT,APSL-2.0}`; GPL-scan clean; `zprint/zprint.c` pinned as sole system_cmds APSL file | `936c0d3` |

> **APSL note (2026-08-24):** the "sole APSL file" claim above is now stale — `include/os/errno.h` (`f56414c`, vendored from Libc) is a second APSL-2.0 file in the tree. Both are covered by `LICENSE.APSL-2.0`; fold this header into the licensing docs on the next licensing pass.
| 2026-08-22 | **Scope decided: Option C** — strict coreutils-like now; diagnostics tier + daemons optional via build flags (`MK_*`, default off); daemons all optional | session 2 |
| 2026-08-22 | Ported `factor`, `timeout`, `indent`, `ee` from FreeBSD (via references/bsdutils) into new non-submodule group `src/bsd_additions/`; meson.build stripped; licenses documented (BSD-4 section added for indent) | working tree |
| 2026-08-24 | Optional tiers wired: `MK_DIAGNOSTICS`/`MK_DAEMONS` knobs (default off) gate 23 diagnostics + 9 daemon progs; default `bmake` = 215 progs, full = 247 | `eb6a7f0` |
| 2026-08-24 | Bucket-B include wiring: `mount_devfs`, `mount_fdesc`, `tftp` now build (mntopts.h/libutil, tftp-*.c helpers, libedit); `umount`/`grep` fragments wired but header-blocked | `858d82b` |
| 2026-08-24 | Staged `include/os/errno.h` (vendored from Libc `libdarwin/h/errno.h`, adapted for stock SDK) → `umount` builds | `f56414c` |

| 2026-08-24 | Private-framework tier (`MK_PRIVATE_FRAMEWORKS`, default off) added; then **all 7 of its tools brought to build** | `dbf9ae2`…`1c9dc84` |
| 2026-08-24 | kextmanager interface recovered: `kextmanager.h` is MIG-generated from in-tree `.defs`, not shipped → `reboot`, `shutdown` | `a4805da`, `a042c02` |
| 2026-08-24 | FSKit/LiveFS interface headers recovered from the dyld shared cache (`ipsw class-dump`): 117 + 37 headers vendored | `86e0822` |
| 2026-08-24 | `mount` (APFS framework), `fsck_fskit`, `newfs_fskit`, `quotacheck`; `fstyp` split into its 4 stock binaries | `631d679`, `4cc6755`, `40a5945`, `1c9dc84` |

| 2026-08-24 | `src/hfs` submodule added; `fstyp_hfs` wired → all five stock `fstyp*` binaries build | `4d0fd58`, `53cb92c` |
| 2026-08-24 | `src/hfs` triaged vs stock `/sbin`: `mount_hfs`, `newfs_hfs` added (wipefs/ExtentManager into libutil); `fsck_hfs` wired but blocked | `6b6e251`, `ffcbb6c`, `116bece` |
| 2026-08-24 | `DiskImages2/DICommon.h` recovered from Apple's shipped `mount_hfs` binary (CFSTR literals) | `6b6e251` |
| 2026-08-24 | Clean-build hygiene: `libfsck_hfs.a` out of `lib`'s `all`; dropped the unusable xnu `sys/tree.h` that shadowed localedef's bundled copy | `883a06f`, `4b5d8c7` |
| 2026-08-24 | `su` unblocked: `<SoftLinking/SoftLinking.h>` reconstructed from its call sites as dlopen/dlsym macros | `7462fae` |
| 2026-08-24 | `fsck_hfs` unblocked — the `<Errors.h>` hunt was moot, dfalib's Carbon includes sit in the `#else` of `#if BSD`; `-DBSD=1` + FSKit C hooks + generated vers_string | `88d7984`, `e5c2474` |
| 2026-08-24 | `taskpolicy` (extract of xnu's private IOPOL/PRIO_DARWIN defines) and `timeout` (Darwin prctl shim + sys_signame compat) | `163b981`, `d9290a0` |
| 2026-08-24 | `ifconfig` — SDK Kernel.framework `if_var_private.h` for the newer netem struct; `IF_NETEM_MODEL_IOD`/`_FPD` recovered by disassembling the shipped `/sbin/ifconfig`. **Whole tree builds.** | `61d1e44` |

**Build status — from-scratch clean build (`rm -rf build`), 2026-08-24: everything builds.**
- default `bmake` — **214 / 214** declared programs
- `bmake MK_PRIVATE_FRAMEWORKS=yes` — **221 / 221** (222 binaries with the `dc` hardlink)
- zero build errors

Three tools build with behavioural caveats recorded in their fragments rather
than glossed over:

- `timeout` — Darwin has no child-subreaper API, so its default mode returns
  when the direct child exits rather than the last descendant.  `--foreground`
  is exact (verified: exit 124).
- `mount`, `fsck_fskit`, `newfs_fskit`, `fsck_hfs` — report FSKit as
  unavailable via `mk/compat/fskit_stub.c`, which is Apple's own `ENOTSUP`
  fallback for that case.
- `ifconfig` — its two newer netem model values are recovered from the shipped
  `/sbin/ifconfig` rather than any published header (see
  `include/net/if_netem_models_private.h`).

## Key findings locked in

- **Link system libs over homebrew** wherever an SDK `.tbd` exists — zero runtime deps beyond stock macOS.
- `/usr/lib/*.dylib` don't exist on disk anymore (dyld shared cache); `.tbd`s are the source of truth.
- `src/libmd` (libmd-7) kept: system libmd exports one-shot wrappers only (no `MD5Init` streaming API), no public headers.
- `src/libtelnet` (libtelnet-13) kept: absent everywhere on modern systems.
- `src/libutil` (libutil-73) kept: SDK has no `libutil.h`. Apple's libutil lacks `login_cap`/`setusercontext` and `sbuf`; FreeBSD's are applied from `mk/patches/libutil`.
- Kerberos.framework exposes full core `krb5_*` API (incl. `sendauth`/`recvauth`) → telnet needs no bundled krb5.

## Open work

1. ~~Scope decision~~ ✅ **Option C** — strict set by default; `MK_DIAGNOSTICS`, `MK_DAEMONS` and `MK_PRIVATE_FRAMEWORKS` tiers all default off.
2. ~~Missing tools~~ ✅ `factor`, `timeout`, `indent`, `ee` vendored into `src/bsd_additions/`. Note: kept as plain tracked dirs, not submodules — revisit if upstream tracking is wanted.
3. ~~`login_cap`/`setusercontext`~~ ✅ in `libutil` (`getcap`/`login_cap`/`login_class` family builds; `wipefs`+`ExtentManager` added for newfs_hfs).
4. ~~Build system (bmake)~~ ✅ complete and driving the whole tree: `mk/progs.mk` inventory → `mk/tool.mk` engine → per-tool `mk/tool.d/*.mk`. Supports codegen (yacc/lex/mig/host build-tools), `T_LINKS` hardlinks, `T_SCRIPT` script installs, `T_NOBUILD`, and framework search paths.
5. ~~Remaining blockers~~ ✅ none — `ifconfig` was the last, closed by force-including the SDK's newer `net/if_var_private.h` and recovering `IF_NETEM_MODEL_IOD`/`_FPD` from the shipped binary.

6. **Packaging** — everything installs flat into `build/release/{bin,sbin,usr/*}`. Stock macOS puts `fsck_hfs`/`newfs_hfs`/`mount_hfs` in `hfs.fs/Contents/Resources` with `/sbin` symlinks; reproducing bundle layout (and symlink support in `tool.mk`) is a cross-cutting decision still open.
7. **FSKit** — 117 FSKit + 37 LiveFS interface headers recovered into `frameworks/`, but they are class-dump output (`id`-typed params). Building the real `disklib/fskit_support.m` against them needs a cleanup pass; until then `mk/compat/fskit_stub.c` supplies Apple's own `ENOTSUP` fallback.

## Suggested next session order

version-matched xnu headers (unblocks ifconfig + taskpolicy) → a real `<Errors.h>` for fsck_hfs → FSKit header cleanup for the real fskit_support.m → bundle-layout decision for the hfs.fs tools
