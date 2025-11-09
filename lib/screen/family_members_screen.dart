import 'package:gia_pha_mobile/model/family_member.dart';
import 'package:flutter/material.dart';
import 'package:gia_pha_mobile/utils/genogram_utils.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:gia_pha_mobile/screen/family_member_detail_screen.dart';

class FamilyMembersScreen extends StatefulWidget {
  const FamilyMembersScreen({super.key});

  @override
  FamilyMembersScreenState createState() => FamilyMembersScreenState();
}

class FamilyMembersScreenState extends State<FamilyMembersScreen> {
  List<FamilyMember> list = GenogramUtils.getSampleFamilyData();

  // Filters: -1 == all
  int genderFilter = -1; // 0 = male, 1 = female, 2 = unknown
  int deceasedFilter = -1; // 0 = alive, 1 = deceased
  int marriedFilter = -1; // 0 = unmarried, 1 = married
  int childrenFilter = -1; // 0 = no children, 1 = has children

  // collapsed by default
  bool filtersExpanded = false;

  // name search
  String nameQuery = '';
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = nameQuery;
    init();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  List<FamilyMember> get filteredList {
    final q = nameQuery.trim().toLowerCase();
    return list.where((data) {
      // name search
      if (q.isNotEmpty) {
        final name = (data.name ?? '').toLowerCase();
        if (!name.contains(q)) return false;
      }

      // gender
      if (genderFilter != -1 && data.gender != genderFilter) return false;

      // deceased
      if (deceasedFilter != -1) {
        final bool isDeceased = data.isDeceased ?? false;
        if ((deceasedFilter == 1) != isDeceased) return false;
      }

      // married (use dynamic access so missing field doesn't cause compile error)
      if (marriedFilter != -1) {
        bool isMarried = false;
        try {
          final dyn = data as dynamic;
          isMarried = (dyn.isMarried ?? false) as bool;
        } catch (_) {
          isMarried = false;
        }
        if ((marriedFilter == 1) != isMarried) return false;
      }

      // has children (use dynamic access)
      if (childrenFilter != -1) {
        bool hasChildren = false;
        try {
          final dyn = data as dynamic;
          final ch = dyn.children;
          if (ch is Iterable) hasChildren = ch.isNotEmpty;
          else hasChildren = false;
        } catch (_) {
          hasChildren = false;
        }
        if ((childrenFilter == 1) != hasChildren) return false;
      }

      return true;
    }).toList();
  }

  Widget _buildFilterChips() {
    return ExpansionTile(
      leading: const Icon(Icons.filter_list),
      title: Row(
        children: [
          const Text('Filters'),
          8.width,
          Text('(${filteredList.length})', style: secondaryTextStyle()),
        ],
      ),
      initiallyExpanded: filtersExpanded,
      onExpansionChanged: (v) => setState(() => filtersExpanded = v),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name search field
              TextField(
                controller: _nameController,
                onChanged: (v) => setState(() => nameQuery = v),
                decoration: InputDecoration(
                  isDense: true,
                  hintText: 'Search by name',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: nameQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => setState(() {
                            _nameController.clear();
                            nameQuery = '';
                          }),
                        )
                      : null,
                  border: OutlineInputBorder(borderRadius: radius(8)),
                ),
              ),
              8.height,
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  // Gender chips
                  ChoiceChip(
                    label: const Text('All genders'),
                    selected: genderFilter == -1,
                    onSelected: (_) => setState(() => genderFilter = -1),
                  ),
                  ChoiceChip(
                    label: const Text('Male'),
                    selected: genderFilter == 0,
                    onSelected: (_) => setState(() => genderFilter = 0),
                  ),
                  ChoiceChip(
                    label: const Text('Female'),
                    selected: genderFilter == 1,
                    onSelected: (_) => setState(() => genderFilter = 1),
                  ),
                  ChoiceChip(
                    label: const Text('Unknown'),
                    selected: genderFilter == 2,
                    onSelected: (_) => setState(() => genderFilter = 2),
                  ),
                ],
              ),
              8.height,
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('All status'),
                    selected: deceasedFilter == -1,
                    onSelected: (_) => setState(() => deceasedFilter = -1),
                  ),
                  ChoiceChip(
                    label: const Text('Alive'),
                    selected: deceasedFilter == 0,
                    onSelected: (_) => setState(() => deceasedFilter = 0),
                  ),
                  ChoiceChip(
                    label: const Text('Deceased'),
                    selected: deceasedFilter == 1,
                    onSelected: (_) => setState(() => deceasedFilter = 1),
                  ),
                ],
              ),
              8.height,
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('All married'),
                    selected: marriedFilter == -1,
                    onSelected: (_) => setState(() => marriedFilter = -1),
                  ),
                  ChoiceChip(
                    label: const Text('Married'),
                    selected: marriedFilter == 1,
                    onSelected: (_) => setState(() => marriedFilter = 1),
                  ),
                  ChoiceChip(
                    label: const Text('Unmarried'),
                    selected: marriedFilter == 0,
                    onSelected: (_) => setState(() => marriedFilter = 0),
                  ),
                ],
              ),
              8.height,
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('All children'),
                    selected: childrenFilter == -1,
                    onSelected: (_) => setState(() => childrenFilter = -1),
                  ),
                  ChoiceChip(
                    label: const Text('Has children'),
                    selected: childrenFilter == 1,
                    onSelected: (_) => setState(() => childrenFilter = 1),
                  ),
                  ChoiceChip(
                    label: const Text('No children'),
                    selected: childrenFilter == 0,
                    onSelected: (_) => setState(() => childrenFilter = 0),
                  ),
                ],
              ),
              8.height,
              Row(
                children: [
                  TextButton(
                    onPressed: () => setState(() {
                      genderFilter = -1;
                      deceasedFilter = -1;
                      marriedFilter = -1;
                      childrenFilter = -1;
                      nameQuery = '';
                      _nameController.clear();
                    }),
                    child: const Text('Clear filters'),
                  ),
                  8.width,
                  Text('${filteredList.length} result(s)').paddingLeft(8),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = filteredList;
    return Scaffold(
      body: Column(
        children: [
          _buildFilterChips(),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                FamilyMember data = items[index];
                return Container(
                  margin: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Center(
                        child: ClipOval(
                          child: Container(
                            width: 48,
                            height: 48,
                            color: Colors.grey.shade700,
                            child: data.avatarUrl != null
                                ? ColorFiltered(
                                    // tint the image to a single grey color when deceased,
                                    // otherwise show the normal image
                                    colorFilter: data.isDeceased
                                        ? ColorFilter.mode(Colors.grey.shade700, BlendMode.color)
                                        : const ColorFilter.mode(Colors.transparent, BlendMode.dst),
                                    child: data.avatarUrl!.startsWith('http')
                                        ? Image.network(
                                            data.avatarUrl!,
                                            fit: BoxFit.cover,
                                            width: 48,
                                            height: 48,
                                          )
                                        : Image.asset(
                                            data.avatarUrl!,
                                            fit: BoxFit.cover,
                                            width: 48,
                                            height: 48,
                                          ),
                                  )
                                : Icon(
                                    data.gender == 1 ? Icons.person_outline : Icons.person,
                                    size: 28,
                                    color: Colors.grey.shade900,
                                  ),
                          ),
                        ),
                      ),
                      16.width,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data.name, style: boldTextStyle()),
                          4.height,
                          Row(
                            children: [
                              Chip(
                                backgroundColor: Colors.grey.shade100,
                                label: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      data.gender == 0
                                          ? Icons.male
                                          : data.gender == 1
                                              ? Icons.female
                                              : Icons.person,
                                      size: 16,
                                      color: Colors.blueGrey,
                                    ),
                                    6.width,
                                    Text(
                                      data.gender == 0
                                          ? 'Male'
                                          : data.gender == 1
                                              ? 'Female'
                                              : 'Unknown',
                                      style: secondaryTextStyle(size: 12),
                                    ),
                                  ],
                                ),
                              ),
                              8.width,
                              Chip(
                                backgroundColor: Colors.grey.shade100,
                                label: Text(data.kinship, style: secondaryTextStyle(size: 12)),
                              ),
                            ],
                          ),
                        ],
                      ).expand(),
                      // Contextual actions menu — view details / view on tree / share / copy
                      PopupMenuButton<String>(
                        onSelected: (value) async {
                          if (value == 'details') {
                            // TODO: navigate to a detail screen or show a bottom sheet
                            // Navigator.push(context, MaterialPageRoute(builder: (_) => MemberDetailScreen(member: data)));
                          } else if (value == 'view_on_tree') {
                            // TODO: open FamilyTreeScreen and focus the member (implement focus in tree)
                            // Navigator.push(context, MaterialPageRoute(builder: (_) => FamilyTreeScreen()));
                          } else if (value == 'share') {
                            // TODO: use share package to share member info
                            // Share.share('${data.name} — ${data.add}');
                          } else if (value == 'copy') {
                            //await Clipboard.setData(ClipboardData(text: data.name));
                            if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied name to clipboard')));
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(value: 'details', child: Text('View details')),
                          const PopupMenuItem(value: 'view_on_tree', child: Text('View on family tree')),
                          const PopupMenuItem(value: 'share', child: Text('Share')),
                          const PopupMenuItem(value: 'copy', child: Text('Copy name')),
                        ],
                        icon: const Icon(Icons.more_vert),
                      ),
                    ],
                  ),
                ).onTap(() {
                  FamilyMemberDetailScreen(member: items[index]).launch(context);
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
