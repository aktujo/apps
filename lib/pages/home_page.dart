// SPDX-License-Identifier: MIT
import 'dart:async';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../src/rust/api/archive.dart';
import 'document_page.dart';
import 'join_page.dart';
import 'kinds_page.dart';
import 'scan_page.dart';
import 'sync_page.dart';

/// The archive: its spaces, the documents of the chosen one, search, adding files and the bin.
class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.archive, this.pickFiles});

  final Archive archive;

  /// How files are chosen – the system's dialog, or paths given by a test.
  final Future<List<String>> Function()? pickFiles;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<SpaceItem> _spaces = [];
  String? _space;
  List<DocumentItem> _documents = [];
  String _words = '';
  bool _bin = false;
  String? _message;
  Timer? _searching;
  Timer? _refresh;

  Archive get _archive => widget.archive;

  @override
  void initState() {
    super.initState();
    _load();
    // What is read in the background shows as it is done.
    _refresh = Timer.periodic(const Duration(seconds: 3), (_) {
      if (_documents.any((d) => d.reading == 'waiting' || d.reading == 'reading')) _loadDocuments();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Names of kinds and fields in the app's language.
    _archive.setLanguage(language: Localizations.localeOf(context).languageCode);
  }

  @override
  void dispose() {
    _searching?.cancel();
    _refresh?.cancel();
    super.dispose();
  }

  Future<void> _run(Future<void> Function() action) async {
    try {
      await action();
    } catch (error) {
      if (mounted) setState(() => _message = AppLocalizations.of(context).error('$error'));
    }
  }

  Future<void> _load() => _run(() async {
    final spaces = await _archive.spaces();
    setState(() {
      _spaces = spaces;
      if (!spaces.any((s) => s.id == _space)) _space = spaces.isEmpty ? null : spaces.first.id;
    });
    await _loadDocuments();
  });

  Future<void> _loadDocuments() => _run(() async {
    final space = _space;
    if (space == null) return;
    final documents = await _archive.documents(space: space, words: _words, bin: _bin);
    if (mounted && space == _space) setState(() => _documents = documents);
  });

  Future<void> _foundSpace() async {
    final l = AppLocalizations.of(context);
    final name = await _ask(l.spaceNew, l.spaceName);
    if (name == null || name.trim().isEmpty) return;
    await _run(() async {
      _space = await _archive.foundSpace(name: name);
      await _load();
    });
  }

  Future<void> _join() async {
    final space = await Navigator.push<String>(context, MaterialPageRoute(builder: (_) => JoinPage(archive: _archive)));
    if (space == null) return;
    _space = space;
    if (mounted) setState(() => _message = AppLocalizations.of(context).joining);
    await _load();
  }

  Future<void> _scan() async {
    final space = _space;
    if (space == null) return;
    final id = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => ScanPage(archive: _archive, space: space),
      ),
    );
    await _load();
    if (id != null && mounted) {
      await Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (_) => DocumentPage(archive: _archive, space: space, document: id),
        ),
      );
      await _load();
    }
  }

  Future<void> _openKinds() async {
    final space = _space;
    if (space == null) return;
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => KindsPage(archive: _archive, space: space),
      ),
    );
    await _load();
  }

  Future<void> _openSync() async {
    final space = _space;
    if (space == null) return;
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => SyncPage(archive: _archive, space: space),
      ),
    );
    await _load();
  }

  Future<String?> _ask(String title, String label) {
    final controller = TextEditingController();
    final l = AppLocalizations.of(context);
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(labelText: label),
          onSubmitted: (value) => Navigator.pop(context, value),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(l.cancel)),
          FilledButton(onPressed: () => Navigator.pop(context, controller.text), child: Text(l.spaceFound)),
        ],
      ),
    );
  }

  Future<List<String>> _pick() async {
    const group = XTypeGroup(
      label: 'PDF, PNG, JPEG, TIFF',
      extensions: ['pdf', 'png', 'jpg', 'jpeg', 'tif', 'tiff'],
      mimeTypes: ['application/pdf', 'image/png', 'image/jpeg', 'image/tiff'],
      uniformTypeIdentifiers: ['com.adobe.pdf', 'public.png', 'public.jpeg', 'public.tiff'],
    );
    final files = await openFiles(acceptedTypeGroups: [group]);
    return files.map((f) => f.path).toList();
  }

  Future<void> _addFiles() async {
    final space = _space;
    if (space == null) return;
    final paths = await (widget.pickFiles ?? _pick)();
    if (paths.isEmpty) return;
    await _run(() async {
      final added = await _archive.addFiles(space: space, paths: paths);
      if (mounted) setState(() => _message = AppLocalizations.of(context).docAdded(added));
      await _load();
    });
  }

  void _search(String words) {
    _words = words;
    _searching?.cancel();
    _searching = Timer(const Duration(milliseconds: 250), _loadDocuments);
  }

  Future<void> _open(DocumentItem item) async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => DocumentPage(archive: _archive, space: item.space, document: item.id),
      ),
    );
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final wide = MediaQuery.sizeOf(context).width >= 760;
    final spaces = _SpaceList(
      spaces: _spaces,
      chosen: _space,
      onChoose: (id) {
        setState(() {
          _space = id;
          _documents = [];
        });
        if (!wide) Navigator.maybePop(context);
        _loadDocuments();
      },
      onFound: _foundSpace,
      onJoin: _join,
    );
    final body = _space == null
        ? _FirstSpace(onFound: _foundSpace, onJoin: _join)
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(prefixIcon: const Icon(Icons.search), hintText: l.search),
                        onChanged: _search,
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: Text(l.bin),
                      selected: _bin,
                      onSelected: (on) {
                        setState(() => _bin = on);
                        _loadDocuments();
                      },
                    ),
                  ],
                ),
              ),
              if (_message != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(_message!, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                ),
              Expanded(
                child: _documents.isEmpty
                    ? Center(child: Text(_words.isEmpty && !_bin ? l.noDocuments : l.nothingFound))
                    : ListView.separated(
                        itemCount: _documents.length,
                        separatorBuilder: (_, _) => const Divider(height: 1),
                        itemBuilder: (context, i) =>
                            _DocumentRow(item: _documents[i], onTap: () => _open(_documents[i])),
                      ),
              ),
            ],
          );
    final title = _spaces.where((s) => s.id == _space).map((s) => s.name).firstOrNull ?? l.appTitle;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          if (_space != null)
            IconButton(icon: const Icon(Icons.category_outlined), tooltip: l.kindsTitle, onPressed: _openKinds),
          if (_space != null)
            IconButton(
              icon: Icon(
                _spaces.where((s) => s.id == _space).firstOrNull?.relay == null ? Icons.cloud_off : Icons.sync,
              ),
              tooltip: l.syncTitle,
              onPressed: _openSync,
            ),
        ],
      ),
      drawer: wide ? null : Drawer(child: SafeArea(child: spaces)),
      floatingActionButton: _space == null
          ? null
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FloatingActionButton.small(
                  heroTag: 'scan',
                  tooltip: l.scan,
                  onPressed: _scan,
                  child: const Icon(Icons.document_scanner),
                ),
                const SizedBox(height: 12),
                FloatingActionButton.extended(
                  heroTag: 'add',
                  onPressed: _addFiles,
                  icon: const Icon(Icons.add),
                  label: Text(l.docAdd),
                ),
              ],
            ),
      body: wide
          ? Row(
              children: [
                SizedBox(width: 240, child: spaces),
                const VerticalDivider(width: 1),
                Expanded(child: body),
              ],
            )
          : body,
    );
  }
}

class _SpaceList extends StatelessWidget {
  const _SpaceList({
    required this.spaces,
    required this.chosen,
    required this.onChoose,
    required this.onFound,
    required this.onJoin,
  });

  final List<SpaceItem> spaces;
  final String? chosen;
  final void Function(String) onChoose;
  final VoidCallback onFound;
  final VoidCallback onJoin;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(l.spaces, style: Theme.of(context).textTheme.titleLarge),
        ),
        for (final space in spaces)
          ListTile(
            title: Text(space.name.isEmpty ? '…' : space.name),
            leading: space.relay == null ? null : Icon(space.waiting ? Icons.hourglass_empty : Icons.sync, size: 18),
            trailing: Text('${space.documents}'),
            selected: space.id == chosen,
            onTap: () => onChoose(space.id),
          ),
        ListTile(leading: const Icon(Icons.add), title: Text(l.spaceNew), onTap: onFound),
        ListTile(leading: const Icon(Icons.group_add), title: Text(l.settingsJoin), onTap: onJoin),
      ],
    );
  }
}

class _FirstSpace extends StatelessWidget {
  const _FirstSpace({required this.onFound, required this.onJoin});

  final VoidCallback onFound;
  final VoidCallback onJoin;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l.tagline, style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            Text(l.firstSpace, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(onPressed: onFound, child: Text(l.spaceNew)),
            const SizedBox(height: 8),
            TextButton(onPressed: onJoin, child: Text(l.settingsJoin)),
          ],
        ),
      ),
    );
  }
}

class _DocumentRow extends StatelessWidget {
  const _DocumentRow({required this.item, required this.onTap});

  final DocumentItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final muted = TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant);
    final state = switch (item.reading) {
      'waiting' => l.waiting,
      'reading' => l.reading,
      'failed' => l.failed,
      _ => null,
    };
    final details = [item.date, ?item.kind, ...item.labels, ?state];
    return ListTile(
      title: Text(item.title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(details.join(' · '), style: muted),
          if (item.excerpt.isNotEmpty) Text(item.excerpt, maxLines: 2, overflow: TextOverflow.ellipsis, style: muted),
        ],
      ),
      onTap: onTap,
    );
  }
}
