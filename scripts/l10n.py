#!/usr/bin/env python3
# SPDX-License-Identifier: MIT
# Writes the app's translations, lib/l10n/app_<language>.arb, from two sources: the texts aktujo's web app and
# terminal interface share (the crate aktujo-locales, in the version rust/Cargo.lock holds) and the app's own
# (l10n/app_<language>.arb). A shared key becomes a Dart name (`space.new` → `spaceNew`, `doc.added` → `docAdded`);
# what is filled in (`{n}`) becomes a placeholder. The terminal interface's texts (`tui.`) are left out. An own key that
# is a shared one too is an error – rename it. Then `flutter gen-l10n`. With --check, it only compares (CI).
#   scripts/l10n.py [--check]
import json
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
LANGUAGES = ["en", "de"]


def shared_folder():
    """The folder `locales/` of aktujo-locales, as cargo has it for rust/Cargo.lock."""
    metadata = subprocess.run(
        ["cargo", "metadata", "--locked", "--format-version", "1", "--manifest-path", str(ROOT / "rust/Cargo.toml")],
        check=True, capture_output=True, text=True,
    )
    for package in json.loads(metadata.stdout)["packages"]:
        if package["name"] == "aktujo-locales":
            return Path(package["manifest_path"]).parent / "locales"
    sys.exit("aktujo-locales is not a dependency of rust/Cargo.toml")


def dart_name(key):
    return re.sub(r"[._]([A-Za-z0-9])", lambda m: m.group(1).upper(), key)


def arb(language, shared, own):
    out = {"@@locale": language}
    for key, text in shared.items():
        if key.startswith("tui."):
            continue
        name = dart_name(key)
        out[name] = text
        placeholders = list(dict.fromkeys(re.findall(r"\{(\w+)\}", text)))
        if placeholders and language == "en":
            out[f"@{name}"] = {"placeholders": {p: {} for p in placeholders}}
    for key, value in own.items():
        if key == "@@locale":
            continue
        if key in out:
            sys.exit(f"l10n/app_{language}.arb: {key} is a shared text of aktujo-locales too – rename it")
        out[key] = value
    return json.dumps(out, indent=2, ensure_ascii=False) + "\n"


def main():
    folder = shared_folder()
    stale = []
    for language in LANGUAGES:
        shared = json.loads((folder / f"{language}.json").read_text(encoding="utf-8"))
        own = json.loads((ROOT / f"l10n/app_{language}.arb").read_text(encoding="utf-8"))
        target = ROOT / f"lib/l10n/app_{language}.arb"
        text = arb(language, shared, own)
        if target.exists() and target.read_text(encoding="utf-8") == text:
            continue
        if "--check" in sys.argv:
            stale.append(str(target.relative_to(ROOT)))
        else:
            target.write_text(text, encoding="utf-8")
    if stale:
        sys.exit("not up to date – run scripts/l10n.py: " + ", ".join(stale))


main()
