// SPDX-License-Identifier: MIT
import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../src/rust/api/archive.dart';
import '../ui/dialogs.dart';

/// A document: its title, labels, fields, versions and the text read from it; into the bin and out again.
class DocumentPage extends StatefulWidget {
  const DocumentPage({super.key, required this.archive, required this.space, required this.document});

  final Archive archive;
  final String space;
  final String document;

  @override
  State<DocumentPage> createState() => _DocumentPageState();
}

class _DocumentPageState extends State<DocumentPage> {
  DocumentDetail? _detail;
  List<KindItem> _kinds = [];
  String? _message;
  final _label = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _label.dispose();
    super.dispose();
  }

  Future<void> _run(Future<void> Function() action) async {
    try {
      await action();
      await _load();
    } catch (error) {
      if (mounted) setState(() => _message = AppLocalizations.of(context).error('$error'));
    }
  }

  Future<void> _load() async {
    final detail = await widget.archive.document(space: widget.space, document: widget.document);
    final kinds = await widget.archive.kinds(space: widget.space);
    if (mounted) {
      setState(() {
        _detail = detail;
        _kinds = kinds;
      });
    }
  }

  Future<void> _editField(FieldItem field) async {
    final l = AppLocalizations.of(context);
    final text = await askText(
      context,
      title: field.name,
      label: typeLabel(l, field.fieldType),
      initial: field.value.isEmpty ? (field.suggested ?? '') : field.value,
      hint: typeHint(l, field.fieldType),
    );
    if (text == null) return;
    await _run(
      () => widget.archive.setField(space: widget.space, document: widget.document, key: field.key, text: text),
    );
  }

  String _kindName(String id) => _kinds.where((k) => k.id == id).map((k) => k.name).firstOrNull ?? id;

  Future<void> _rename(String title) async {
    final l = AppLocalizations.of(context);
    final controller = TextEditingController(text: title);
    final text = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.docTitle),
        content: TextField(controller: controller, autofocus: true, onSubmitted: (v) => Navigator.pop(context, v)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(l.cancel)),
          FilledButton(onPressed: () => Navigator.pop(context, controller.text), child: Text(l.save)),
        ],
      ),
    );
    if (text == null || text.trim().isEmpty) return;
    await _run(() => widget.archive.setTitle(space: widget.space, document: widget.document, title: text));
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final detail = _detail;
    if (detail == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    final item = detail.item;
    final heading = Theme.of(context).textTheme.titleMedium;
    final muted = TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant);
    return Scaffold(
      appBar: AppBar(
        title: Text(item.title),
        actions: [
          IconButton(icon: const Icon(Icons.edit), tooltip: l.docTitle, onPressed: () => _rename(item.title)),
          IconButton(
            icon: Icon(item.trashed ? Icons.restore_from_trash : Icons.delete_outline),
            tooltip: item.trashed ? l.fromBin : l.toBin,
            onPressed: () => _run(
              () => widget.archive.setTrashed(space: widget.space, document: widget.document, trashed: !item.trashed),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text([item.date, ?item.kind].join(' · '), style: muted),
          if (_message != null) Text(_message!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
          const SizedBox(height: 16),
          Text(l.docLabels, style: heading),
          Wrap(
            spacing: 8,
            children: [
              for (final label in item.labels)
                InputChip(
                  label: Text(label),
                  onDeleted: () => _run(
                    () => widget.archive.removeLabel(space: widget.space, document: widget.document, label: label),
                  ),
                ),
              SizedBox(
                width: 200,
                child: TextField(
                  controller: _label,
                  decoration: InputDecoration(hintText: l.docAddLabel),
                  onSubmitted: (label) {
                    _label.clear();
                    if (label.trim().isEmpty) return;
                    _run(() => widget.archive.addLabel(space: widget.space, document: widget.document, label: label));
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(l.docKind, style: heading),
          Row(
            children: [
              Expanded(
                child: DropdownButton<String?>(
                  isExpanded: true,
                  value: _kinds.any((k) => k.id == detail.kindId) ? detail.kindId : null,
                  hint: Text(l.docNoKind),
                  items: [
                    DropdownMenuItem<String?>(value: null, child: Text(l.docNoKind)),
                    for (final kind in _kinds) DropdownMenuItem<String?>(value: kind.id, child: Text(kind.name)),
                  ],
                  onChanged: (kind) =>
                      _run(() => widget.archive.setKind(space: widget.space, document: widget.document, kind: kind)),
                ),
              ),
            ],
          ),
          if (detail.kindSuggested != null) Text(l.suggestedKind(_kindName(detail.kindSuggested!)), style: muted),
          if (detail.kindSuggested != null || detail.fields.any((f) => f.suggested != null))
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () =>
                    _run(() => widget.archive.confirmSuggestions(space: widget.space, document: widget.document)),
                child: Text(l.confirmSuggestions),
              ),
            ),
          if (detail.fields.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(l.docFields, style: heading),
            for (final field in detail.fields)
              ListTile(
                dense: true,
                title: Text(field.name),
                subtitle: Text(
                  [
                    field.value.isEmpty ? l.noValue : field.value,
                    if (field.suggested != null) '${field.suggested} (${l.docSuggested})',
                  ].join(' · '),
                ),
                trailing: const Icon(Icons.edit, size: 18),
                onTap: () => _editField(field),
              ),
          ],
          const SizedBox(height: 16),
          Text(l.docVersions, style: heading),
          for (final version in detail.versions)
            ListTile(
              dense: true,
              leading: Text('v${version.number}'),
              title: Text(version.name),
              subtitle: Text('${version.mediaType} · ${(version.size.toInt() / 1024).ceil()} KiB'),
            ),
          const SizedBox(height: 16),
          Text(l.text, style: heading),
          const SizedBox(height: 8),
          SelectableText(detail.text.isEmpty ? l.noText : detail.text),
        ],
      ),
    );
  }
}
