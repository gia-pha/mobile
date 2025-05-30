import 'package:gia_pha_mobile/model/EAForYouModel.dart';
// import 'package:event_flutter/screens/EAChattingScreen.dart';
import 'package:gia_pha_mobile/utils/EAColors.dart';
import 'package:gia_pha_mobile/utils/EADataProvider.dart';
import 'package:gia_pha_mobile/utils/EAapp_widgets.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class EAMayBEYouKnowScreen extends StatefulWidget {
  const EAMayBEYouKnowScreen({super.key});

  @override
  EAMayBEYouKnowScreenState createState() => EAMayBEYouKnowScreenState();
}

class EAMayBEYouKnowScreenState extends State<EAMayBEYouKnowScreen> {
  List<EAForYouModel> list = getMayKnowData();

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
          EAForYouModel data = list[index];
          return Container(
            margin: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                commonCachedNetworkImage(data.image,
                        fit: BoxFit.cover, height: 60, width: 60)
                    .cornerRadiusWithClipRRect(35),
                16.width,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data.name!, style: boldTextStyle()),
                    4.height,
                    Text(data.add!, style: secondaryTextStyle()),
                  ],
                ).expand(),
                IconButton(
                  onPressed: () {
                    list[index].fev = !list[index].fev!;
                    setState(() {});
                  },
                  icon: list[index].fev!
                      ? Icon(Icons.person_remove,
                          color: list[index].fev! ? primaryColor1 : black)
                      : Icon(Icons.person_add_alt_1,
                          color: list[index].fev! ? primaryColor1 : black),
                ),
              ],
            ),
          ).onTap(() {
            //  String? userImg = list[index].image;
            String? username = list[index].name;

            //EAChattingScreen(name: username).launch(context);
          });
        },
      ),
    );
  }
}
