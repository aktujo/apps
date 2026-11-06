// SPDX-License-Identifier: MIT
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';

import '../src/rust/api/archive.dart';

/// Where the key of the data folder is kept in the system's secure storage.
const _keyName = 'aktujo.data-folder';

const keptKeys = FlutterSecureStorage(
  // This device only, readable after the first unlock – also for syncing in the background later.
  iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock_this_device),
  // The login keychain: the data protection keychain would need a signing team's entitlement.
  mOptions: MacOsOptions(
    accessibility: KeychainAccessibility.first_unlock_this_device,
    usesDataProtectionKeychain: false,
  ),
);

/// Opens the archive in the app's own folder for application data – or makes it – or in [folder]. Its key is kept in
/// the system's secure storage (Keychain, Android Keystore, Credential Manager, Secret Service), never beside the
/// folder.
Future<Archive> openArchive({
  FlutterSecureStorage storage = keptKeys,
  String? folder,
  String keyName = _keyName,
}) async {
  final path = folder ?? '${(await getApplicationSupportDirectory()).path}${Platform.pathSeparator}aktujo';
  final key = await storage.read(key: keyName);
  final archive = Archive.open(folder: path, key: key);
  if (key == null) {
    await storage.write(key: keyName, value: archive.key());
  }
  return archive;
}
