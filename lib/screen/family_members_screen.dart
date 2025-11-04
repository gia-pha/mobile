import 'package:gia_pha_mobile/model/EAForYouModel.dart';
import 'package:gia_pha_mobile/model/FamilyMember.dart';
// import 'package:event_flutter/screens/EAChattingScreen.dart';
import 'package:gia_pha_mobile/utils/EAColors.dart';
import 'package:gia_pha_mobile/utils/EADataProvider.dart';
import 'package:gia_pha_mobile/utils/EAapp_widgets.dart';
import 'package:flutter/material.dart';
import 'package:gia_pha_mobile/utils/genogram_utils.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:gia_pha_mobile/screen/family_member_detail_screen.dart';

class EAMayBEYouKnowScreen extends StatefulWidget {
  const EAMayBEYouKnowScreen({super.key});

  @override
  EAMayBEYouKnowScreenState createState() => EAMayBEYouKnowScreenState();
}

class EAMayBEYouKnowScreenState extends State<EAMayBEYouKnowScreen> {
  List<FamilyMember> list = GenogramUtils.getSampleFamilyData();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        shrinkWrap: true,
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          FamilyMember data = list[index];
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
            FamilyMemberDetailScreen(member: list[index]).launch(context);
          });
        },
      ),
    );
  }
}
