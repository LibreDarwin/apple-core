#!/usr/bin/env python3
# mk/scripts/pbxinfo.py -- what an Apple .xcodeproj says about a target.
#
#	pbxinfo.py <submodule-dir>              list every target
#	pbxinfo.py <submodule-dir> <target>     sources and build settings
#	pbxinfo.py <submodule-dir> <target> <T_DIR>
#	                                        the same, with the sources as a
#	                                        T_SRCS assignment for that T_DIR
#
# Apple's source lists and flags live in their project files and nowhere
# else, so a mk/tool.d fragment is written from this rather than guessed.
# Sources print relative to the submodule root, ready for T_SRCS once the
# tool's own directory is stripped.  Reads the project with plutil, which
# understands the old-style property list format pbxproj files use.

import glob, json, os, subprocess, sys

SETTINGS = ("PRODUCT_NAME", "EXECUTABLE_PREFIX", "EXECUTABLE_EXTENSION",
            "INSTALL_PATH", "DYLIB_INSTALL_NAME_BASE", "HEADER_SEARCH_PATHS",
            "USER_HEADER_SEARCH_PATHS", "GCC_PREPROCESSOR_DEFINITIONS",
            "OTHER_CFLAGS", "OTHER_LDFLAGS", "LIBRARY_SEARCH_PATHS",
            "GCC_C_LANGUAGE_STANDARD", "CLANG_ENABLE_OBJC_ARC",
            "EXPORTED_SYMBOLS_FILE", "CODE_SIGN_ENTITLEMENTS")

def main():
    root = sys.argv[1].rstrip("/")
    projs = sorted(glob.glob(root + "/*.xcodeproj"))
    if not projs:
        sys.exit("no .xcodeproj in " + root)
    want = sys.argv[2] if len(sys.argv) > 2 else None
    tdir = sys.argv[3].strip("/") if len(sys.argv) > 3 else None
    srcs = []
    for proj in projs:
        d = json.loads(subprocess.run(
            ["plutil", "-convert", "json", "-o", "-", proj + "/project.pbxproj"],
            capture_output=True, check=True).stdout)
        o = d["objects"]
        top = o[d["rootObject"]]
        parent = {}
        for k, v in o.items():
            for c in v.get("children", []):
                parent[c] = k

        def path_of(ref):
            v = o[ref]
            p = v.get("path", "")
            tree = v.get("sourceTree", "<group>")
            if tree == "<group>" and ref in parent:
                return os.path.normpath(os.path.join(path_of(parent[ref]), p))
            if tree in ("<group>", "SOURCE_ROOT"):
                return os.path.normpath(p) if p else ""
            return "$(%s)/%s" % (tree, p)

        def settings(cfglist):
            cfgs = [o[c] for c in o[cfglist]["buildConfigurations"]]
            rel = [c for c in cfgs if c.get("name") == "Release"] or cfgs
            c = rel[0]
            s = dict(c.get("buildSettings", {}))
            if "baseConfigurationReference" in c:
                s["(xcconfig)"] = path_of(c["baseConfigurationReference"])
            return s

        psett = settings(top["buildConfigurationList"])
        for t in top["targets"]:
            tg = o[t]
            ptype = tg.get("productType", tg["isa"]).replace("com.apple.product-type.", "")
            if want is None:
                s = settings(tg["buildConfigurationList"])
                print("%-28s %-18s %s" % (tg["name"], ptype,
                      s.get("INSTALL_PATH", psett.get("INSTALL_PATH", ""))))
                continue
            if tg["name"] != want:
                continue
            s = dict(psett)
            s.update(settings(tg["buildConfigurationList"]))
            print("# %s (%s) in %s" % (tg["name"], ptype, os.path.basename(proj)))
            for k in SETTINGS + ("(xcconfig)",):
                if k in s:
                    v = s[k]
                    print("%s = %s" % (k, " ".join(v) if isinstance(v, list) else v))
            for ph in tg.get("buildPhases", []):
                phase = o[ph]
                kind = phase["isa"]
                if kind not in ("PBXSourcesBuildPhase", "PBXFrameworksBuildPhase"):
                    continue
                label = "SRCS" if kind == "PBXSourcesBuildPhase" else "LINK"
                for bf in phase.get("files", []):
                    ref = o[bf].get("fileRef")
                    if ref:
                        flags = o[bf].get("settings", {}).get("COMPILER_FLAGS", "")
                        path = path_of(ref)
                        print("%s %s%s" % (label, path,
                                           "  [" + flags + "]" if flags else ""))
                        if label == "SRCS":
                            srcs.append(path)
            for dep in tg.get("dependencies", []):
                print("DEP %s" % o[o[dep]["target"]]["name"])

    if tdir is not None:
        print_t_srcs(root, tdir, srcs)

COMPILED = (".c", ".m", ".cc", ".cpp", ".s", ".y", ".l")

def print_t_srcs(root, tdir, srcs):
    # A source inside T_DIR is named by its basename; anything else by its
    # TOP-relative path, which mk/tool.mk takes as such because it has a
    # slash.  Generated sources ($(BUILT_PRODUCTS_DIR)/...) are left for
    # the fragment to produce, and listed so they are not forgotten.
    top_src = os.path.normpath(os.path.join(os.path.relpath(root), ".."))
    sub = os.path.basename(os.path.normpath(root))
    words, generated = [], []
    for p in srcs:
        if not p.endswith(COMPILED):
            continue
        if p.startswith("$("):
            generated.append(p)
            continue
        full = os.path.normpath(os.path.join("src", sub, p))
        if os.path.dirname(full) == os.path.normpath(os.path.join("src", tdir)):
            words.append(os.path.basename(full))
        else:
            words.append(full)
    lines, cur = [], "T_SRCS=\t"
    for w in words:
        if len(cur.expandtabs(8)) + len(w) > 72:
            lines.append(cur.rstrip() + " \\")
            cur = "\t\t"
        cur += w + " "
    lines.append(cur.rstrip())
    print()
    print("\n".join(lines))
    for g in generated:
        print("# generated, not listed: %s" % g)

if __name__ == "__main__":
    main()
