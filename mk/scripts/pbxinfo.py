#!/usr/bin/env python3
# mk/scripts/pbxinfo.py -- what an Apple .xcodeproj says about a target.
#
#	pbxinfo.py <submodule-dir>              list every target
#	pbxinfo.py <submodule-dir> <target>     sources and build settings
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
                        print("%s %s" % (label, path_of(ref)))
            for dep in tg.get("dependencies", []):
                print("DEP %s" % o[o[dep]["target"]]["name"])

if __name__ == "__main__":
    main()
