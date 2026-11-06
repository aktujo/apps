// SPDX-License-Identifier: MIT
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/app_localizations.dart';
import '../src/rust/api/archive.dart';

/// Sync and sharing of a space: starting it through a relay (the recovery code shown once), syncing now, inviting
/// devices and people, and its members.
class SyncPage extends StatefulWidget {
  const SyncPage({super.key, required this.archive, required this.space});

  final Archive archive;
  final String space;

  @override
  State<SyncPage> createState() => _SyncPageState();
}

class _SyncPageState extends State<SyncPage> {
  SpaceItem? _space;
  List<MemberItem> _members = [];
  String? _message;
  String? _error;
  bool _busy = false;
  String _rights = 'write';
  final _relay = TextEditingController();
  final _name = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _relay.dispose();
    _name.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final spaces = await widget.archive.spaces();
    final space = spaces.where((s) => s.id == widget.space).firstOrNull;
    final name = await widget.archive.deviceName();
    List<MemberItem> members = [];
    if (space?.relay != null && space?.rights != null) {
      try {
        members = await widget.archive.members(space: widget.space);
      } catch (_) {
        // The relay may not be reachable now; the members show once it is.
      }
    }
    if (!mounted) return;
    setState(() {
      _space = space;
      _members = members;
      if (_name.text.isEmpty && name != null) _name.text = name;
    });
  }

  Future<void> _run(Future<void> Function() action) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await action();
    } catch (error) {
      if (mounted) setState(() => _error = AppLocalizations.of(context).error('$error'));
    }
    if (mounted) setState(() => _busy = false);
    await _load();
  }

  Future<void> _start() => _run(() async {
    final code = await widget.archive.startSync(space: widget.space, relay: _relay.text.trim(), name: _name.text);
    if (!mounted) return;
    final l = AppLocalizations.of(context);
    await _show(l.syncCode, l.recoveryCodeHint, code);
  });

  Future<void> _syncNow() => _run(() async {
    final report = await widget.archive.syncNow(space: widget.space);
    if (mounted) setState(() => _message = AppLocalizations.of(context).syncReport(report.received, report.sent));
  });

  Future<void> _invite() => _run(() async {
    final invitation = await widget.archive.invite(space: widget.space, rights: _rights);
    if (!mounted) return;
    final l = AppLocalizations.of(context);
    await _show(l.syncInvitationField, l.inviteHint, invitation);
  });

  Future<void> _remove(MemberItem member) async {
    final l = AppLocalizations.of(context);
    final name = member.name ?? member.id;
    final sure = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(l.removeMemberConfirm(name)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l.cancel)),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(l.syncRemove)),
        ],
      ),
    );
    if (sure != true) return;
    await _run(() => widget.archive.removeMember(space: widget.space, member: member.id));
  }

  /// Shows a secret – a recovery code, an invitation – to copy, once.
  Future<void> _show(String title, String hint, String text) {
    final l = AppLocalizations.of(context);
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(hint),
            const SizedBox(height: 12),
            SelectableText(text, style: const TextStyle(fontFamily: 'monospace')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: text));
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.syncCopied)));
              }
            },
            child: Text(l.syncCopy),
          ),
          FilledButton(onPressed: () => Navigator.pop(context), child: Text(l.done)),
        ],
      ),
    );
  }

  String _rightsText(AppLocalizations l, String rights) => switch (rights) {
    'read' => l.mayRead,
    'manage' => l.mayManage,
    _ => l.mayWrite,
  };

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final space = _space;
    final muted = TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant);
    final heading = Theme.of(context).textTheme.titleMedium;
    return Scaffold(
      appBar: AppBar(title: Text(l.syncTitle)),
      body: space == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(l.syncHint, style: muted),
                const SizedBox(height: 16),
                if (_error != null) Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                if (space.relay == null) ...[
                  TextField(
                    controller: _relay,
                    keyboardType: TextInputType.url,
                    decoration: InputDecoration(labelText: l.syncRelay, hintText: 'http://192.168.1.10:8072'),
                  ),
                  TextField(
                    controller: _name,
                    decoration: InputDecoration(labelText: l.settingsDeviceName, helperText: l.deviceNameHint),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(onPressed: _busy ? null : _start, child: Text(l.syncStart)),
                ] else ...[
                  Text(space.relay!, style: heading),
                  if (space.rights != null) Text(_rightsText(l, space.rights!), style: muted),
                  if (space.waiting) Text(l.waitingToBeAdded),
                  Text(
                    space.syncedAt == null
                        ? l.notSynced
                        : l.syncedAt(
                            TimeOfDay.fromDateTime(DateTime.fromMillisecondsSinceEpoch(space.syncedAt!.toInt()))
                                .format(context),
                          ),
                    style: muted,
                  ),
                  if (space.syncProblem != null)
                    Text(space.syncProblem!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                  if (_message != null) Text(_message!, style: muted),
                  const SizedBox(height: 8),
                  OutlinedButton(onPressed: _busy ? null : _syncNow, child: Text(l.syncNow)),
                  if (space.rights == 'manage') ...[
                    const SizedBox(height: 24),
                    Text(l.invite, style: heading),
                    Text(l.inviteHint, style: muted),
                    const SizedBox(height: 8),
                    SegmentedButton<String>(
                      segments: [
                        ButtonSegment(value: 'read', label: Text(l.mayRead)),
                        ButtonSegment(value: 'write', label: Text(l.mayWrite)),
                        ButtonSegment(value: 'manage', label: Text(l.mayManage)),
                      ],
                      selected: {_rights},
                      onSelectionChanged: (chosen) => setState(() => _rights = chosen.first),
                    ),
                    const SizedBox(height: 8),
                    FilledButton(onPressed: _busy ? null : _invite, child: Text(l.invite)),
                  ],
                  if (_members.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text(l.syncMembers, style: heading),
                    for (final member in _members)
                      ListTile(
                        title: Text(member.role == 'recovery' ? l.syncCode : (member.name ?? member.id)),
                        subtitle: Text(_rightsText(l, member.rights)),
                        trailing: space.rights == 'manage' && member.role != 'recovery'
                            ? TextButton(onPressed: () => _remove(member), child: Text(l.syncRemove))
                            : null,
                      ),
                  ],
                ],
              ],
            ),
    );
  }
}
