// SPDX-License-Identifier: MIT
import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

/// Asks for a line of text; none if cancelled.
Future<String?> askText(
  BuildContext context, {
  required String title,
  required String label,
  String initial = '',
  String? hint,
  String? action,
}) {
  final controller = TextEditingController(text: initial);
  final l = AppLocalizations.of(context);
  return showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: InputDecoration(labelText: label, hintText: hint),
        onSubmitted: (value) => Navigator.pop(context, value),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l.cancel)),
        FilledButton(onPressed: () => Navigator.pop(context, controller.text), child: Text(action ?? l.save)),
      ],
    ),
  );
}

/// Asks whether to go on; true if confirmed.
Future<bool> askSure(BuildContext context, String question, String action) async {
  final l = AppLocalizations.of(context);
  final sure = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      content: Text(question),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l.cancel)),
        FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(action)),
      ],
    ),
  );
  return sure ?? false;
}

/// The name of a type of field, as people read it.
String typeLabel(AppLocalizations l, String type) => switch (type) {
  'date' => l.typeDate,
  'money' => l.typeMoney,
  'number' => l.typeNumber,
  'flag' => l.typeFlag,
  _ => l.typeText,
};

/// How a value of a type is typed.
String? typeHint(AppLocalizations l, String type) => switch (type) {
  'date' => l.hintDate,
  'money' => l.hintMoney,
  'number' => l.hintNumber,
  'flag' => l.hintFlag,
  _ => null,
};
