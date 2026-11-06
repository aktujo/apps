// SPDX-License-Identifier: MIT
import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../src/rust/api/archive.dart';

/// Joining a space with an invitation, or bringing one back with its recovery code. Pops with the space's identity.
class JoinPage extends StatefulWidget {
  const JoinPage({super.key, required this.archive});

  final Archive archive;

  @override
  State<JoinPage> createState() => _JoinPageState();
}

class _JoinPageState extends State<JoinPage> {
  final _invitation = TextEditingController();
  final _name = TextEditingController();
  final _relay = TextEditingController();
  final _space = TextEditingController();
  final _code = TextEditingController();
  String? _error;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    widget.archive.deviceName().then((name) {
      if (mounted && name != null && _name.text.isEmpty) _name.text = name;
    });
  }

  @override
  void dispose() {
    for (final c in [_invitation, _name, _relay, _space, _code]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _run(Future<String> Function() action) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final space = await action();
      if (mounted) Navigator.pop(context, space);
    } catch (error) {
      if (mounted) setState(() => _error = AppLocalizations.of(context).error('$error'));
    }
    if (mounted) setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final muted = TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant);
    final heading = Theme.of(context).textTheme.titleMedium;
    return Scaffold(
      appBar: AppBar(title: Text(l.join)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_error != null) Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
          TextField(
            controller: _name,
            decoration: InputDecoration(labelText: l.deviceName, helperText: l.deviceNameHint),
          ),
          const SizedBox(height: 24),
          Text(l.join, style: heading),
          Text(l.joinHint, style: muted),
          TextField(
            controller: _invitation,
            decoration: InputDecoration(labelText: l.invitation),
            maxLines: 3,
            minLines: 1,
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: _busy
                ? null
                : () => _run(() => widget.archive.join(invitation: _invitation.text, name: _name.text)),
            child: Text(l.join),
          ),
          const SizedBox(height: 32),
          Text(l.recover, style: heading),
          Text(l.recoverHint, style: muted),
          TextField(
            controller: _relay,
            keyboardType: TextInputType.url,
            decoration: InputDecoration(labelText: l.relay),
          ),
          TextField(
            controller: _space,
            decoration: InputDecoration(labelText: l.spaceId),
          ),
          TextField(
            controller: _code,
            decoration: InputDecoration(labelText: l.code),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: _busy
                ? null
                : () => _run(() async {
                    await widget.archive.recover(
                      relay: _relay.text,
                      space: _space.text,
                      code: _code.text,
                      name: _name.text,
                    );
                    return _space.text.trim();
                  }),
            child: Text(l.recover),
          ),
        ],
      ),
    );
  }
}
