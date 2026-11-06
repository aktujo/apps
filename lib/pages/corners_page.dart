// SPDX-License-Identifier: MIT
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../src/rust/api/archive.dart';

/// The corners of the sheet in a photo, to move by hand: four handles over the photo as it is. Pops with eight shares –
/// x and y of the top left, top right, bottom right and bottom left – or with an empty list for the whole photo.
class CornersPage extends StatefulWidget {
  const CornersPage({super.key, required this.path, this.corners});

  /// The photo.
  final String path;

  /// The corners to start from; the whole photo if none.
  final List<double>? corners;

  @override
  State<CornersPage> createState() => _CornersPageState();
}

/// The corners of the whole photo.
const List<double> wholePhoto = [0, 0, 1, 0, 1, 1, 0, 1];

/// Whether eight shares make a sheet: within the photo, convex, clockwise on screen from the top left.
bool isSheet(List<double> c) {
  if (c.length != 8 || c.any((v) => !v.isFinite || v < 0 || v > 1)) return false;
  for (var i = 0; i < 4; i++) {
    final (ax, ay) = (c[2 * i], c[2 * i + 1]);
    final (bx, by) = (c[2 * ((i + 1) % 4)], c[2 * ((i + 1) % 4) + 1]);
    final (cx, cy) = (c[2 * ((i + 2) % 4)], c[2 * ((i + 2) % 4) + 1]);
    if ((bx - ax) * (cy - by) - (by - ay) * (cx - bx) <= 0) return false;
  }
  return true;
}

class _CornersPageState extends State<CornersPage> {
  late final List<double> _corners = List.of(widget.corners ?? wholePhoto);
  Uint8List? _photo;
  Size? _size;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final png = await scanPhoto(path: widget.path, width: 1400);
      final image = await decodeImageFromList(png);
      if (!mounted) return;
      setState(() {
        _photo = png;
        _size = Size(image.width.toDouble(), image.height.toDouble());
      });
    } catch (error) {
      if (mounted) setState(() => _error = AppLocalizations.of(context).error('$error'));
    }
  }

  void _drag(int corner, Offset by, Size shown) {
    setState(() {
      _corners[2 * corner] = (_corners[2 * corner] + by.dx / shown.width).clamp(0.0, 1.0);
      _corners[2 * corner + 1] = (_corners[2 * corner + 1] + by.dy / shown.height).clamp(0.0, 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final sheet = isSheet(_corners);
    return Scaffold(
      appBar: AppBar(
        title: Text(l.corners),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, <double>[]), child: Text(l.wholePhoto)),
          TextButton(onPressed: sheet ? () => Navigator.pop(context, _corners) : null, child: Text(l.done)),
        ],
      ),
      body: Column(
        children: [
          Padding(padding: const EdgeInsets.all(12), child: Text(_error ?? l.cornersHint)),
          Expanded(
            child: _photo == null || _size == null
                ? const Center(child: CircularProgressIndicator())
                : LayoutBuilder(
                    builder: (context, room) {
                      // The photo as large as fits, its handles on it.
                      final scale = [
                        room.maxWidth / _size!.width,
                        room.maxHeight / _size!.height,
                      ].reduce((a, b) => a < b ? a : b);
                      final shown = Size(_size!.width * scale, _size!.height * scale);
                      final points = [
                        for (var i = 0; i < 4; i++)
                          Offset(_corners[2 * i] * shown.width, _corners[2 * i + 1] * shown.height),
                      ];
                      const handle = 44.0;
                      return Center(
                        child: SizedBox.fromSize(
                          size: shown,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Positioned.fill(child: Image.memory(_photo!, fit: BoxFit.fill, gaplessPlayback: true)),
                              Positioned.fill(
                                child: CustomPaint(
                                  painter: _Outline(points, sheet ? Theme.of(context).colorScheme.primary : Colors.red),
                                ),
                              ),
                              for (final (i, point) in points.indexed)
                                Positioned(
                                  left: point.dx - handle / 2,
                                  top: point.dy - handle / 2,
                                  width: handle,
                                  height: handle,
                                  child: Semantics(
                                    label: '${l.corners} ${i + 1}',
                                    child: GestureDetector(
                                      key: ValueKey('corner-$i'),
                                      behavior: HitTestBehavior.opaque,
                                      onPanUpdate: (details) => _drag(i, details.delta, shown),
                                      child: Center(
                                        child: Container(
                                          width: 22,
                                          height: 22,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white.withValues(alpha: 0.85),
                                            border: Border.all(color: Theme.of(context).colorScheme.primary, width: 3),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

/// The outline of the sheet between its corners, the photo outside it dimmed.
class _Outline extends CustomPainter {
  _Outline(this.points, this.colour);

  final List<Offset> points;
  final Color colour;

  @override
  void paint(Canvas canvas, Size size) {
    final sheet = Path()..addPolygon(points, true);
    final outside = Path.combine(ui.PathOperation.difference, Path()..addRect(Offset.zero & size), sheet);
    canvas.drawPath(outside, Paint()..color = Colors.black.withValues(alpha: 0.4));
    canvas.drawPath(
      sheet,
      Paint()
        ..color = colour
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(_Outline old) => old.points != points || old.colour != colour;
}
