# aktujo apps

**aktujo for desktop and mobile – scan, file, find.** A [falkOSS](https://falkoss.org) project.

The apps of [aktujo](https://github.com/aktujo/aktujo): a person's archive on their devices – documents with their
versions, labels, kinds and fields, search and the bin – end-to-end encrypted, later scanned with the camera and kept
in step between devices. One Flutter app for macOS, iOS, Linux, Android and Windows, built on aktujo's SDK
(`aktujo-sdk`, MIT), which the program aktujo uses as well. The design is
[RFC 0006](https://github.com/aktujo/aktujo/blob/main/docs/rfc/0006-apps-and-sdk.md).

aktujo is at its beginning: the apps keep an archive on the device – its spaces and documents – and sync and share
spaces through a relay you run yourself (`aktujo relay`): invitations with rights, joining, members, the recovery code.
Kinds of documents are the space's own – made in the app, imported from a file or taken from a catalog of templates
(the official one, [aktujo/catalog](https://github.com/aktujo/catalog), and others) – with their fields, confirmed
or suggested. Their page will be
[aktujo.app](https://aktujo.app); until then the website is [aktujo.org](https://aktujo.org).

## Layout

| Path | What |
|---|---|
| `lib/` | the app in Dart: `main.dart`, `app/` (opening the archive, its key in the system's secure storage), `pages/`, `ui/theme.dart` (aktujo's colours and Space Mono), `l10n/` (English and German) |
| `lib/src/rust/` | the bindings to the Rust side – generated |
| `rust/` | the Rust side (`aktujo_bridge`): `src/api/` translates `aktujo-sdk` for Dart; a workspace of its own with exact, permissive dependencies |
| `rust_builder/` | cargokit, which builds `rust/` for each platform |
| `integration_test/` | the app with its real Rust side, on a device |

## Build and check

aktujo's SDK comes from crates.io, in the version of aktujo's release. You need Flutter, Rust (the version in `rust/rust-toolchain.toml`), and for the bindings
`flutter_rust_bridge_codegen` 2.13.0.

```sh
flutter pub get
flutter_rust_bridge_codegen generate          # after changing rust/src/api/
flutter run -d macos                          # or ios, android, linux, windows
(cd rust && cargo fmt --check && cargo clippy --locked --all-targets -- -D warnings && cargo test --locked && cargo deny check)
dart format --output=none --set-exit-if-changed lib integration_test && flutter analyze
flutter test integration_test -d macos
# with a relay of your own as well (aktujo relay --data <folder> --listen 127.0.0.1:18072):
flutter test integration_test -d macos --dart-define=AKTUJO_TEST_RELAY=http://127.0.0.1:18072
```

## Licence

[MIT](LICENSE), so the apps can be published in the app stores; an SPDX header in every source file
([REUSE](https://reuse.software)). Cargokit (`rust_builder/cargokit/`) is MIT OR Apache-2.0; Space Mono is
OFL-1.1; the app icons are copies from [aktujo/brand](https://github.com/aktujo/brand) under CC BY-ND 4.0. The brand
(name, logo, marks) is not covered by any licence. Contributing: [CONTRIBUTING.md](CONTRIBUTING.md).

© 2026 falkOSS – Falcon Lake Open Source Software gUG (haftungsbeschränkt) i. G. and the aktujo contributors
