// SPDX-License-Identifier: MIT
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../src/rust/api/archive.dart';
import '../ui/dialogs.dart';
import 'catalog_page.dart';

/// The kinds of a space: added, renamed, removed; their fields and words; a file of kinds imported, or a template
/// taken from a catalog.
class KindsPage extends StatefulWidget {
  const KindsPage({super.key, required this.archive, required this.space, this.pickFile});

  final Archive archive;
  final String space;

  /// How a file of kinds is chosen – the system's dialog, or a path given by a test.
  final Future<String?> Function()? pickFile;

  @override
  State<KindsPage> createState() => _KindsPageState();
}

class _KindsPageState extends State<KindsPage> {
  List<KindItem>? _kinds;
  String? _message;
  String? _error;

  Archive get _archive => widget.archive;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final kinds = await _archive.kinds(space: widget.space);
    if (mounted) setState(() => _kinds = kinds);
  }

  Future<void> _run(Future<void> Function() action) async {
    try {
      await action();
      if (mounted) setState(() => _error = null);
    } catch (error) {
      if (mounted) setState(() => _error = AppLocalizations.of(context).error('$error'));
    }
    await _load();
  }

  Future<void> _addKind() async {
    final l = AppLocalizations.of(context);
    final name = await askText(context, title: l.addKind, label: l.kindName, action: l.addKind);
    if (name == null || name.trim().isEmpty) return;
    await _run(() => _archive.addKind(space: widget.space, name: name));
  }

  Future<void> _rename(KindItem kind) async {
    final l = AppLocalizations.of(context);
    final name = await askText(context, title: l.rename, label: l.kindName, initial: kind.name);
    if (name == null || name.trim().isEmpty) return;
    await _run(() => _archive.renameKind(space: widget.space, kind: kind.id, name: name));
  }

  Future<void> _remove(KindItem kind) async {
    final l = AppLocalizations.of(context);
    if (!await askSure(context, l.removeKindConfirm(kind.name), l.remove)) return;
    await _run(() => _archive.removeKind(space: widget.space, kind: kind.id));
  }

  Future<void> _addField(KindItem kind) async {
    final l = AppLocalizations.of(context);
    final name = TextEditingController();
    var type = 'text';
    final added = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialog) => AlertDialog(
          title: Text(l.addField),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: name,
                autofocus: true,
                decoration: InputDecoration(labelText: l.fieldName),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: type,
                decoration: InputDecoration(labelText: l.kindsFieldType),
                items: [
                  for (final t in ['text', 'date', 'money', 'number', 'flag'])
                    DropdownMenuItem(value: t, child: Text(typeLabel(l, t))),
                ],
                onChanged: (t) => setDialog(() => type = t ?? 'text'),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l.cancel)),
            FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(l.addField)),
          ],
        ),
      ),
    );
    if (added != true || name.text.trim().isEmpty) return;
    await _run(() => _archive.addField(space: widget.space, kind: kind.id, name: name.text, fieldType: type));
  }

  Future<void> _addWord(KindItem kind) async {
    final l = AppLocalizations.of(context);
    final word = TextEditingController();
    final weight = TextEditingController(text: '6');
    final added = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.addWord),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l.wordsHint),
            TextField(
              controller: word,
              autofocus: true,
              decoration: InputDecoration(labelText: l.word),
            ),
            TextField(
              controller: weight,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: l.weight),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l.cancel)),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(l.addWord)),
        ],
      ),
    );
    if (added != true || word.text.trim().isEmpty) return;
    final value = int.tryParse(weight.text.trim()) ?? 1;
    await _run(() => _archive.setWord(space: widget.space, kind: kind.id, word: word.text, weight: value));
  }

  Future<String?> _pickJson() async {
    const group = XTypeGroup(
      label: 'JSON',
      extensions: ['json'],
      mimeTypes: ['application/json'],
      uniformTypeIdentifiers: ['public.json'],
    );
    return (await openFile(acceptedTypeGroups: [group]))?.path;
  }

  Future<void> _import() async {
    final path = await (widget.pickFile ?? _pickJson)();
    if (path == null) return;
    await _run(() async {
      final changed = await _archive.importKinds(space: widget.space, path: path);
      if (mounted) setState(() => _message = AppLocalizations.of(context).imported(changed));
    });
  }

  Future<void> _catalog() async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => CatalogPage(archive: _archive, space: widget.space),
      ),
    );
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final kinds = _kinds;
    final muted = TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant);
    return Scaffold(
      appBar: AppBar(
        title: Text(l.kindsTitle),
        actions: [
          IconButton(icon: const Icon(Icons.storefront), tooltip: l.catalog, onPressed: _catalog),
          IconButton(icon: const Icon(Icons.file_open), tooltip: l.importKinds, onPressed: _import),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addKind,
        icon: const Icon(Icons.add),
        label: Text(l.addKind),
      ),
      body: kinds == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
              children: [
                Text(l.kindsIntro, style: muted),
                if (_message != null) Text(_message!, style: muted),
                if (_error != null) Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                const SizedBox(height: 8),
                if (kinds.isEmpty) Padding(padding: const EdgeInsets.only(top: 24), child: Text(l.noKinds)),
                for (final kind in kinds)
                  Card(
                    margin: const EdgeInsets.only(top: 12),
                    child: ExpansionTile(
                      title: Text(kind.name),
                      subtitle: Text(kind.fields.map((f) => f.name).join(', '), style: muted),
                      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final field in kind.fields)
                          ListTile(
                            dense: true,
                            title: Text(field.name),
                            subtitle: Text('${field.key} · ${typeLabel(l, field.fieldType)}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.close),
                              tooltip: l.remove,
                              onPressed: () =>
                                  _run(() => _archive.removeField(space: widget.space, kind: kind.id, key: field.key)),
                            ),
                          ),
                        Text(l.words, style: Theme.of(context).textTheme.titleSmall),
                        Wrap(
                          spacing: 8,
                          children: [
                            for (final word in kind.words)
                              InputChip(
                                label: Text('${word.word} ${word.weight}'),
                                onDeleted: () => _run(
                                  () =>
                                      _archive.setWord(space: widget.space, kind: kind.id, word: word.word, weight: 0),
                                ),
                              ),
                          ],
                        ),
                        Wrap(
                          spacing: 8,
                          children: [
                            TextButton(onPressed: () => _addField(kind), child: Text(l.addField)),
                            TextButton(onPressed: () => _addWord(kind), child: Text(l.addWord)),
                            TextButton(onPressed: () => _rename(kind), child: Text(l.rename)),
                            TextButton(onPressed: () => _remove(kind), child: Text(l.remove)),
                          ],
                        ),
                      ],
                    ),
                  ),
              ],
            ),
    );
  }
}
