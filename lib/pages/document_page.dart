// SPDX-License-Identifier: MIT
import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../src/rust/api/archive.dart';

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
    if (mounted) setState(() => _detail = detail);
  }

  Future<void> _rename(String title) async {
    final l = AppLocalizations.of(context);
    final controller = TextEditingController(text: title);
    final text = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.title),
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
          IconButton(icon: const Icon(Icons.edit), tooltip: l.title, onPressed: () => _rename(item.title)),
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
          Text(l.labels, style: heading),
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
                  decoration: InputDecoration(hintText: l.addLabel),
                  onSubmitted: (label) {
                    _label.clear();
                    if (label.trim().isEmpty) return;
                    _run(() => widget.archive.addLabel(space: widget.space, document: widget.document, label: label));
                  },
                ),
              ),
            ],
          ),
          if (detail.fields.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(l.fields, style: heading),
            for (final field in detail.fields)
              ListTile(
                dense: true,
                title: Text(field.name),
                subtitle: Text(field.confirmed ? field.value : '${field.value} (${l.suggested})'),
              ),
          ],
          const SizedBox(height: 16),
          Text(l.versions, style: heading),
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
