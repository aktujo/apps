# Contributing to aktujo's apps

Thank you for helping. The rules for every aktujo repository – sign-off, licences, everything included, no
telemetry – are in the [organisation's CONTRIBUTING.md](https://github.com/aktujo/.github/blob/main/CONTRIBUTING.md).
This file adds how to work on this one.

## Build and test

Flutter (stable), Rust from `rust/rust-toolchain.toml` (put `~/.cargo/bin` first on `PATH`), and for the bindings
`flutter_rust_bridge_codegen` 2.13.0.

```sh
flutter pub get
flutter_rust_bridge_codegen generate && (cd rust && cargo fmt)    # after changing rust/src/api/
scripts/l10n.py && flutter gen-l10n                              # after changing l10n/*.arb or aktujo-locales
(cd rust && cargo fmt --check && cargo clippy --locked --all-targets -- -D warnings && cargo test --locked && cargo deny check)
dart format --output=none --set-exit-if-changed lib integration_test && flutter analyze
flutter test integration_test -d macos                            # the app with its real Rust side
scripts/check-age.py                                              # after changing rust/Cargo.lock
```

The archive is aktujo's SDK (`aktujo-sdk` on crates.io); `rust/src/api/` only translates it for Dart. A change the
archive needs belongs in [aktujo/aktujo](https://github.com/aktujo/aktujo). Strings of the app's own go into `l10n/app_en.arb`
and `app_de.arb`; the texts it shares with aktujo's web app and terminal interface come from `aktujo-locales` and are
changed in aktujo/aktujo. Colours, fonts and the icons come from [aktujo/brand](https://github.com/aktujo/brand) only – copied,
never drawn or edited here.
