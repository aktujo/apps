// SPDX-License-Identifier: MIT
import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../l10n/app_localizations.dart';
import '../src/rust/api/archive.dart';
import '../ui/dialogs.dart';

/// Phones and tablets hand an export to the system's share sheet (Files, a drive, mail); computers save it where the
/// person says.
bool get _phone => Platform.isIOS || Platform.isAndroid;

/// Exports a space as a ZIP, after saying it is not encrypted; returns what to tell the person, none if cancelled.
/// [saveTo] chooses where on a computer – the system's dialog, or a path given by a test.
Future<String?> exportSpace(
  BuildContext context,
  Archive archive,
  String space, {
  Future<String?> Function(String suggested)? saveTo,
}) async {
  final l = AppLocalizations.of(context);
  if (!await askSure(context, l.spaceExportHint, l.spaceExport)) return null;
  final name = await archive.exportFileName(space: space);
  String? path;
  if (_phone) {
    final folder = await getTemporaryDirectory();
    path = '${folder.path}${Platform.pathSeparator}$name';
    final old = File(path);
    if (old.existsSync()) old.deleteSync();
  } else {
    path = await (saveTo ?? (suggested) async => (await getSaveLocation(suggestedName: suggested))?.path)(name);
  }
  if (path == null) return null;
  final exported = await archive.exportSpace(space: space, path: path);
  if (_phone) {
    await SharePlus.instance.share(ShareParams(files: [XFile(path, mimeType: 'application/zip')]));
  }
  return [l.exported(exported.documents), if (exported.missing > 0) l.exportedMissing(exported.missing)].join(' ');
}

/// Reads an export back in as a new space; returns its identity and what to tell the person, none if cancelled.
/// [pickZip] chooses the file – the system's dialog, or a path given by a test.
Future<(String, String)?> importSpace(
  BuildContext context,
  Archive archive, {
  Future<String?> Function()? pickZip,
}) async {
  final l = AppLocalizations.of(context);
  const group = XTypeGroup(
    label: 'ZIP',
    extensions: ['zip'],
    mimeTypes: ['application/zip'],
    uniformTypeIdentifiers: ['public.zip-archive'],
  );
  final path = await (pickZip ?? () async => (await openFile(acceptedTypeGroups: [group]))?.path)();
  if (path == null || !context.mounted) return null;
  final name = await askText(context, title: l.importTitle, label: l.importName, action: l.importStart);
  if (name == null) return null;
  final imported = await archive.importSpace(path: path, name: name);
  final note = [
    l.importDone(imported.documents, imported.kinds),
    if (imported.missing > 0) l.importMissing(imported.missing),
    if (imported.skipped.isNotEmpty) l.importSkipped(imported.skipped.join('; ')),
  ].join(' ');
  return (imported.space, note);
}
