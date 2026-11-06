// SPDX-License-Identifier: MIT
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../l10n/app_localizations.dart';
import '../src/rust/api/archive.dart';
import 'corners_page.dart';

/// A scan: pages photographed or chosen, each shown as it will be – the sheet found and its perspective corrected (its
/// corners can be moved), turned, straightened, trimmed, grey or black and white – and saved as one PDF. Pops with the new document's identity.
class ScanPage extends StatefulWidget {
  const ScanPage({super.key, required this.archive, required this.space, this.pickImages});

  final Archive archive;
  final String space;

  /// How images are chosen – the system's dialog, or paths given by a test.
  final Future<List<String>> Function()? pickImages;

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _Page {
  _Page(this.path);

  final String path;
  int turn = 0;
  Uint8List? preview;

  /// The corners of the sheet – found, or moved by hand; none: the whole photo.
  List<double>? corners;
}

class _ScanPageState extends State<ScanPage> {
  final List<_Page> _pages = [];
  final _title = TextEditingController();
  bool _deskew = true;
  bool _findSheet = true;
  String _colour = 'black_white';
  double _trim = 0;
  bool _busy = false;
  String? _error;
  Timer? _rendering;
  int _generation = 0;

  /// Phones and tablets take photos; computers choose images.
  bool get _camera => Platform.isIOS || Platform.isAndroid;

  @override
  void dispose() {
    _title.dispose();
    _rendering?.cancel();
    super.dispose();
  }

  /// The corners a page is cut along: its own, if the sheet is to be found.
  Float32List _cornersOf(_Page page) =>
      Float32List.fromList(_findSheet && page.corners != null ? page.corners! : const []);

  ScanOptions _options(List<int> turns, [List<Float32List> corners = const []]) => ScanOptions(
    deskew: _deskew,
    colour: _colour,
    turns: Uint8List.fromList(turns),
    cropLeft: _trim,
    cropTop: _trim,
    cropRight: _trim,
    cropBottom: _trim,
    corners: corners,
  );

  /// Renders every page anew, after a pause; an older round that is still running is left behind.
  void _render() {
    _rendering?.cancel();
    _rendering = Timer(const Duration(milliseconds: 250), () async {
      final generation = ++_generation;
      for (final page in List.of(_pages)) {
        try {
          final png = await scanPreview(
            path: page.path,
            turn: page.turn,
            corners: _cornersOf(page),
            options: _options([]),
            width: 600,
          );
          if (!mounted || generation != _generation) return;
          setState(() => page.preview = png);
        } catch (error) {
          if (mounted) setState(() => _error = AppLocalizations.of(context).error('$error'));
        }
      }
    });
  }

  Future<void> _add(List<String> paths) async {
    if (paths.isEmpty) return;
    final added = paths.map(_Page.new).toList();
    setState(() => _pages.addAll(added));
    // The sheet on each photo, found before it is shown.
    for (final page in added) {
      try {
        final found = await scanCorners(path: page.path);
        page.corners = found.isEmpty ? null : found.toList();
      } catch (_) {
        // Shown as it is; the preview tells what is wrong with it.
      }
    }
    _render();
  }

  Future<void> _editCorners(_Page page) async {
    final chosen = await Navigator.push<List<double>>(
      context,
      MaterialPageRoute(
        builder: (_) => CornersPage(path: page.path, corners: page.corners),
      ),
    );
    if (chosen == null || !mounted) return;
    setState(() {
      page.corners = chosen.isEmpty ? null : chosen;
      page.preview = null;
      if (chosen.isNotEmpty) _findSheet = true;
    });
    _render();
  }

  Future<void> _photo() async {
    final photo = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 90);
    if (photo != null) await _add([photo.path]);
  }

  Future<List<String>> _chooseImages() async {
    const group = XTypeGroup(
      label: 'PNG, JPEG, TIFF',
      extensions: ['png', 'jpg', 'jpeg', 'tif', 'tiff'],
      mimeTypes: ['image/png', 'image/jpeg', 'image/tiff'],
      uniformTypeIdentifiers: ['public.png', 'public.jpeg', 'public.tiff'],
    );
    final files = await openFiles(acceptedTypeGroups: [group]);
    return files.map((f) => f.path).toList();
  }

  Future<void> _choose() async => await _add(await (widget.pickImages ?? _chooseImages)());

  void _move(int at, int by) {
    final to = at + by;
    if (to < 0 || to >= _pages.length) return;
    setState(() {
      final page = _pages.removeAt(at);
      _pages.insert(to, page);
    });
  }

  Future<void> _save() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final id = await widget.archive.addScan(
        space: widget.space,
        paths: _pages.map((p) => p.path).toList(),
        title: _title.text,
        options: _options(_pages.map((p) => p.turn).toList(), _pages.map(_cornersOf).toList()),
      );
      if (mounted) Navigator.pop(context, id);
    } catch (error) {
      if (mounted) setState(() => _error = AppLocalizations.of(context).error('$error'));
    }
    if (mounted) setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final muted = TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant);
    return Scaffold(
      appBar: AppBar(title: Text(l.scan)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l.scanHint, style: muted),
          if (_error != null) Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (_camera)
                FilledButton.icon(onPressed: _photo, icon: const Icon(Icons.photo_camera), label: Text(l.takePhoto)),
              OutlinedButton.icon(onPressed: _choose, icon: const Icon(Icons.image), label: Text(l.chooseImages)),
            ],
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l.findSheet),
            value: _findSheet,
            onChanged: (on) {
              setState(() => _findSheet = on);
              _render();
            },
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l.straighten),
            value: _deskew,
            onChanged: (on) {
              setState(() => _deskew = on);
              _render();
            },
          ),
          Text(l.colour),
          const SizedBox(height: 4),
          SegmentedButton<String>(
            segments: [
              ButtonSegment(value: 'keep', label: Text(l.colourKeep)),
              ButtonSegment(value: 'grey', label: Text(l.colourGrey)),
              ButtonSegment(value: 'black_white', label: Text(l.colourBlackWhite)),
            ],
            selected: {_colour},
            onSelectionChanged: (chosen) {
              setState(() => _colour = chosen.first);
              _render();
            },
          ),
          const SizedBox(height: 8),
          Text('${l.trim}: ${(_trim * 100).round()} %'),
          Slider(
            value: _trim,
            max: 0.2,
            divisions: 20,
            label: '${(_trim * 100).round()} %',
            onChanged: (value) => setState(() => _trim = value),
            onChangeEnd: (_) => _render(),
          ),
          const SizedBox(height: 8),
          if (_pages.isEmpty) Text(l.noPages, style: muted),
          for (final (i, page) in _pages.indexed)
            Card(
              margin: const EdgeInsets.only(top: 12),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text(l.page(i + 1))),
                        IconButton(
                          icon: const Icon(Icons.crop_free),
                          tooltip: l.corners,
                          onPressed: () => _editCorners(page),
                        ),
                        IconButton(
                          icon: const Icon(Icons.rotate_right),
                          tooltip: l.turn,
                          onPressed: () {
                            setState(() => page.turn = (page.turn + 1) % 4);
                            _render();
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_upward),
                          tooltip: l.moveUp,
                          onPressed: () => _move(i, -1),
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_downward),
                          tooltip: l.moveDown,
                          onPressed: () => _move(i, 1),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          tooltip: l.remove,
                          onPressed: () => setState(() => _pages.removeAt(i)),
                        ),
                      ],
                    ),
                    if (page.preview == null)
                      const SizedBox(height: 120, child: Center(child: CircularProgressIndicator()))
                    else
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 420),
                        child: Image.memory(page.preview!, gaplessPlayback: true),
                      ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 16),
          TextField(
            controller: _title,
            decoration: InputDecoration(labelText: l.docTitle, hintText: l.scan),
          ),
          const SizedBox(height: 12),
          FilledButton(onPressed: _busy || _pages.isEmpty ? null : _save, child: Text(l.saveScan)),
        ],
      ),
    );
  }
}
