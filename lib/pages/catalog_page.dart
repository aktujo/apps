// SPDX-License-Identifier: MIT
import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../src/rust/api/archive.dart';
import '../ui/dialogs.dart';

/// The templates of the catalogs this device uses, for a space: what taking one over does, and taking it; and the
/// sources themselves.
class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key, required this.archive, required this.space});

  final Archive archive;
  final String space;

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  CatalogItem? _catalog;
  List<SourceItem> _sources = [];
  String? _error;
  bool _loading = true;

  Archive get _archive => widget.archive;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final sources = await _archive.sources();
    CatalogItem? catalog;
    String? error;
    try {
      catalog = await _archive.catalog(space: widget.space);
    } catch (e) {
      error = '$e';
    }
    if (!mounted) return;
    setState(() {
      _sources = sources;
      _catalog = catalog;
      _error = error == null ? null : AppLocalizations.of(context).error(error);
      _loading = false;
    });
  }

  Future<void> _run(Future<void> Function() action) async {
    try {
      await action();
    } catch (error) {
      if (mounted) setState(() => _error = AppLocalizations.of(context).error('$error'));
      return;
    }
    await _load();
  }

  String _step(AppLocalizations l, String step) => switch (step) {
    'new' => l.stepNew,
    'same' => l.stepSame,
    'replace' => l.stepReplace,
    'merge' => l.stepMerge,
    _ => l.stepGone,
  };

  Future<void> _take(TemplateItem template) async {
    final l = AppLocalizations.of(context);
    List<PlannedItem> plan;
    try {
      plan = await _archive.takeTemplate(space: widget.space, source: template.source, id: template.id, take: false);
    } catch (error) {
      if (mounted) setState(() => _error = l.error('$error'));
      return;
    }
    if (!mounted) return;
    final take = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${template.name} – ${l.plan}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final kind in plan)
                ListTile(
                  dense: true,
                  title: Text(kind.name),
                  subtitle: Text(
                    [
                      _step(l, kind.step),
                      if (kind.conflicts.isNotEmpty) l.keptHere(kind.conflicts.join(', ')),
                    ].join(' · '),
                  ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l.cancel)),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(template.standing == 'update' ? l.update : l.take),
          ),
        ],
      ),
    );
    if (take != true) return;
    await _run(() => _archive.takeTemplate(space: widget.space, source: template.source, id: template.id, take: true));
  }

  Future<void> _addSource() async {
    final l = AppLocalizations.of(context);
    final url = await askText(context, title: l.addSource, label: l.sourceAddress, action: l.addSource);
    if (url == null || url.trim().isEmpty) return;
    await _run(() => _archive.addSource(url: url));
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final muted = TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant);
    final heading = Theme.of(context).textTheme.titleMedium;
    final catalog = _catalog;
    return Scaffold(
      appBar: AppBar(title: Text(l.catalog)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l.catalogHint, style: muted),
          if (_error != null) Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
          if (_loading)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            ),
          if (catalog != null) ...[
            for (final problem in catalog.problems)
              Text(problem, style: TextStyle(color: Theme.of(context).colorScheme.error)),
            for (final template in catalog.templates)
              Card(
                margin: const EdgeInsets.only(top: 12),
                child: ListTile(
                  title: Text(template.name),
                  subtitle: Text(
                    [
                      if (template.description.isNotEmpty) template.description,
                      template.kinds.join(', '),
                      '${template.sourceName} · ${switch (template.standing) {
                        'taken' => l.standingTaken,
                        'update' => l.standingUpdate,
                        _ => l.standingNew,
                      }}',
                    ].join('\n'),
                  ),
                  isThreeLine: true,
                  trailing: template.standing == 'taken'
                      ? const Icon(Icons.check)
                      : FilledButton(
                          onPressed: () => _take(template),
                          child: Text(template.standing == 'update' ? l.update : l.take),
                        ),
                ),
              ),
          ],
          const SizedBox(height: 32),
          Text(l.sources, style: heading),
          Text(l.sourcesHint, style: muted),
          for (final source in _sources)
            SwitchListTile(
              value: source.active,
              title: Text(source.url),
              subtitle: source.official ? Text(l.official) : null,
              secondary: source.official
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.delete_outline),
                      tooltip: l.remove,
                      onPressed: () => _run(() => _archive.removeSource(url: source.url)),
                    ),
              onChanged: (on) => _run(() => _archive.setSource(url: source.url, active: on)),
            ),
          TextButton(onPressed: _addSource, child: Text(l.addSource)),
        ],
      ),
    );
  }
}
