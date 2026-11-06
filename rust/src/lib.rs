// SPDX-License-Identifier: MIT
//! The Rust side of aktujo's apps. Dart sees `api` (through flutter_rust_bridge, `frb_generated`); aktujo's SDK
//! (`aktujo-sdk`) keeps the archive on the device.

pub mod api;
mod frb_generated;
