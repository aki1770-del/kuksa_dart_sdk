#!/usr/bin/env python3
"""Read each package's own LICENSE from the pub cache and name its SPDX id.
Never guesses: an unrecognised license is reported as UNKNOWN and is fatal."""
import os, sys, re

CACHE = os.path.join(os.environ.get("PUB_CACHE", os.path.expanduser("~/.pub-cache")),
                     "hosted", "pub.dev")

def spdx(text):
    t = " ".join(text.split())
    if "Apache License" in t and "Version 2.0" in t:
        return "Apache-2.0"
    if "Redistribution and use in source and binary forms" in t:
        if "Neither the name of" in t or "nor the names of" in t:
            return "BSD-3-Clause"
        return "BSD-2-Clause"
    if "Permission is hereby granted, free of charge" in t:
        return "MIT"
    return "UNKNOWN"

bad = False
for line in sys.stdin:
    line = line.strip()
    if not line:
        continue
    m = re.match(r"pub/pub\.dev/-/([^/]+)/(.+)$", line)
    name, ver = m.group(1), m.group(2)
    d = os.path.join(CACHE, f"{name}-{ver}")
    lic = next((os.path.join(d, f) for f in ("LICENSE", "LICENSE.md", "LICENSE.txt", "COPYING")
                if os.path.exists(os.path.join(d, f))), None)
    if lic is None:
        ident, src = "UNKNOWN", "no-license-file"
        bad = True
    else:
        ident = spdx(open(lic, encoding="utf-8", errors="replace").read())
        src = "pub.dev"
        if ident == "UNKNOWN":
            bad = True
    print(f"{line}, {ident}, needs-review, {src}")
sys.exit(1 if bad else 0)
