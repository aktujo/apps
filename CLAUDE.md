<!-- SPDX-License-Identifier: MIT -->
# CLAUDE.md – aktujo apps

Rules for working in this repository. This file is public: nothing personal goes here.

## What this is

The apps of aktujo – one Flutter app for macOS, iOS, Linux, Android and Windows, with a Rust side on aktujo's SDK
(`aktujo-sdk`, MIT). A falkOSS project. The design is RFC 0006 in aktujo/aktujo; the README has the layout and the
checks.

## Principles

- **Everything included:** one edition, every feature free; no paid tiers, licence keys or unlocks.
- **No telemetry.** Only connections that are technically needed or that users start themselves.
- **On the SDK only:** the archive is `aktujo-sdk`'s; `rust/src/api/` translates it for Dart and nothing more. No code
  of aktujo's program (API, terminal interface, command line), which is AGPL.
- **Pure:** no kinds of documents or rules built in, no reference to other programs – as in aktujo itself.
- The same functions on every platform; mobile can do what desktop can.

## Licences

- Everything here: **MIT**, an SPDX header in every own source file; REUSE checked in CI. `rust_builder/cargokit/` is
  MIT OR Apache-2.0 (Matej Knopp), changed for an exact Rust version; Space Mono (`assets/fonts/`) OFL-1.1.
- The app icons (`macos/…/AppIcon.appiconset/`, `ios/…/AppIcon.appiconset/`, `android/…/mipmap-*/ic_launcher.png`,
  `windows/runner/resources/app_icon.ico`) are copies of `apps/` in aktujo/brand under CC BY-ND 4.0 – update them by
  copying, never edit them here.
- Dependencies stay permissive: `cargo deny` for Rust (`rust/deny.toml`).

## Rules

- English in code, docs and commits; commits signed off (`git commit -s`).
- No personal data in tracked files (names, paths like `/Users/…`, hostnames, keys, passwords).
- Claims need a source; unverified statements are marked **OPEN**.
- Dependencies exact (`=x.y.z` in `rust/Cargo.toml`, `pubspec.lock` checked in) and at least 14 days old –
  `scripts/check-age.py` after changing `rust/Cargo.lock`.
- `lib/src/rust/` and `rust/src/frb_generated.rs` are generated (`flutter_rust_bridge_codegen generate`) – change
  `rust/src/api/` and generate again, never edit them.
- Strings: the app's own in `l10n/app_en.arb` and `app_de.arb` (English is the source); the texts shared with aktujo's
  web app and terminal interface come from the crate `aktujo-locales` (`docAdded` for its `doc.added`). Change them
  there, not here. `scripts/l10n.py` writes `lib/l10n/app_*.arb` from both (generated – never edit them), then
  `flutter gen-l10n`; an own key that is a shared one too is an error.
- aktujo's look: colours and Space Mono from aktujo/brand (`lib/ui/theme.dart`); the accent on dark only for areas,
  never for small text.
- Platforms as falkOSS builds them: macOS 27 on Apple silicon, iOS 27, Android 13 (API 33) on arm64, Windows 11 on
  x64, Linux on x64 and arm64.
- Dart lines up to 120 characters, like the Rust side.

## Building – what is not obvious

- The SDK (`aktujo-sdk`) comes from crates.io, exact, in the version of aktujo's release; aktujo's own crates are not
  held to the two weeks (`scripts/check-age.py`, `OWN`). To try a change of the SDK before it is released, point a
  `[patch.crates-io]` in a local, untracked `.cargo/config.toml` at a checkout.
- Rust is pinned in `rust/rust-toolchain.toml`, and cargokit is told the same version in `rust/cargokit.yaml`. Put
  `~/.cargo/bin` first on `PATH`: a Rust of Homebrew has no targets for iOS or Android.
- The key of the data folder is kept by Dart (`flutter_secure_storage`, `lib/app/opening.dart`) – on macOS in the login
  keychain, as the data protection keychain needs a signing team's entitlement – and handed to the SDK on opening.
- OpenSSL is built for SQLCipher; on Windows CI uses Strawberry Perl for it (`OPENSSL_SRC_PERL`).

## Checks

```sh
(cd rust && cargo fmt --check && cargo clippy --locked --all-targets -- -D warnings && cargo test --locked && cargo deny check)
dart format --output=none --set-exit-if-changed lib integration_test && flutter analyze
flutter test integration_test -d macos
```
