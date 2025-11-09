import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gia_pha_mobile/model/family_member.dart';

class FamilyMemberDetailScreen extends StatefulWidget {
  final FamilyMember member;

  /// Optional callback to request focusing this member on the family tree.
  final void Function(String memberId)? onViewOnTree;

  const FamilyMemberDetailScreen({
    super.key,
    required this.member,
    this.onViewOnTree,
  });

  @override
  State<FamilyMemberDetailScreen> createState() => _FamilyMemberDetailScreenState();
}

class _FamilyMemberDetailScreenState extends State<FamilyMemberDetailScreen> {
  String _formatYear(DateTime? d) => d == null ? 'Unknown' : '${d.year}';

  String _ageText(DateTime? birth) {
    if (birth == null) return 'Unknown';
    final now = DateTime.now();
    int age = now.year - birth.year;
    if (now.month < birth.month || (now.month == birth.month && now.day < birth.day)) age--;
    return '$age years';
  }

  @override
  Widget build(BuildContext context) {
    final m = widget.member;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Member details'),
        actions: [
          IconButton(
            tooltip: 'Copy name',
            icon: const Icon(Icons.copy),
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: m.name));
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Name copied')));
            },
          ),
          PopupMenuButton<String>(
            onSelected: (v) {
              if (v == 'share') {
                if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Share not implemented')));
              } else if (v == 'edit') {
                if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Edit not implemented')));
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'share', child: Text('Share')),
              PopupMenuItem(value: 'edit', child: Text('Edit')),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Avatar + basic info
            Row(
              children: [
                ClipOval(
                  child: Container(
                    width: 84,
                    height: 84,
                    color: Colors.grey.shade200,
                    child: m.avatarUrl != null && m.avatarUrl!.isNotEmpty
                        ? ColorFiltered(
                            colorFilter: m.isDeceased
                                ? ColorFilter.mode(Colors.grey.shade600, BlendMode.color)
                                : const ColorFilter.mode(Colors.transparent, BlendMode.dst),
                            child: m.avatarUrl!.startsWith('http')
                                ? Image.network(m.avatarUrl!, fit: BoxFit.cover, width: 84, height: 84)
                                : Image.asset(m.avatarUrl!, fit: BoxFit.cover, width: 84, height: 84),
                          )
                        : Icon(
                            m.gender == 0 ? Icons.male : m.gender == 1 ? Icons.female : Icons.person,
                            size: 44,
                            color: m.isDeceased ? Colors.grey.shade600 : theme.colorScheme.onSurface,
                          ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(m.name),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          Chip(
                            label: Row(mainAxisSize: MainAxisSize.min, children: [
                              Icon(
                                m.gender == 0 ? Icons.male : m.gender == 1 ? Icons.female : Icons.person,
                                size: 16,
                                color: Colors.blueGrey,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                m.gender == 0 ? 'Male' : m.gender == 1 ? 'Female' : 'Unknown',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ]),
                            backgroundColor: Colors.grey.shade100,
                          ),
                          if (m.isDeceased == true)
                            Chip(
                              label: Row(mainAxisSize: MainAxisSize.min, children: const [
                                Icon(Icons.cancel, size: 16, color: Colors.red),
                                SizedBox(width: 6),
                                Text('Deceased', style: TextStyle(fontSize: 12, color: Colors.red)),
                              ]),
                              backgroundColor: Colors.red.shade50,
                            ),
                          if (m.kinship != null && m.kinship!.isNotEmpty)
                            Chip(label: Text(m.kinship!, style: const TextStyle(fontSize: 12)), backgroundColor: Colors.grey.shade100),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Dates / age
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    _detailRow('Born', _formatYear(m.dateOfBirth)),
                    const Divider(),
                    _detailRow('Died', m.isDeceased ? _formatYear(m.dateOfDeath) : '—'),
                    if (!m.isDeceased) ...[
                      const Divider(),
                      _detailRow('Age', _ageText(m.dateOfBirth)),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Relationships
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    _sectionTitle('Relationships'),
                    const SizedBox(height: 8),
                    _relationRow('Father', m.fatherId),
                    _relationRow('Mother', m.motherId),
                    _relationListRow('Spouses', m.spouses),
                    //if (m.children != null && m.children!.isNotEmpty) _relationListRow('Children', m.children),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Extra data
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _sectionTitle('Extra data'),
                    const SizedBox(height: 8),
                    if (m.extraData.isEmpty)
                      const Text('None', style: TextStyle(color: Colors.black54))
                    else
                      Column(
                        children: m.extraData.entries.map((entry) {
                          return ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            title: Text(entry.key),
                            subtitle: Text(entry.value?.toString() ?? ''),
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.map),
                    label: const Text('View on tree'),
                    onPressed: () {
                      if (widget.onViewOnTree != null) {
                        widget.onViewOnTree!(m.id ?? '');
                        Navigator.of(context).maybePop();
                        return;
                      }
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Open family tree not implemented')));
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit'),
                    onPressed: () {
                      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Edit not implemented')));
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String title, String value) {
    return Row(
      children: [
        Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600))),
        Text(value, style: const TextStyle(color: Colors.black87)),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Row(
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      ],
    );
  }

  Widget _relationRow(String label, String? id) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      subtitle: id == null ? const Text('Unknown') : Text(id),
      trailing: id == null
          ? null
          : IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lookup not implemented')));
              },
            ),
    );
  }

  Widget _relationListRow(String label, List<String>? ids) {
    if (ids == null || ids.isEmpty) {
      return ListTile(dense: true, contentPadding: EdgeInsets.zero, title: Text(label), subtitle: const Text('None'));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          children: ids.map((id) {
            return ActionChip(
              label: Text(id),
              onPressed: () {
                if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Open related member not implemented')));
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}