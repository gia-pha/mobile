import 'package:mobile/screens/home_screen.dart';
import 'package:mobile/utils/colors.dart';
import 'package:mobile/utils/constants.dart';
import 'package:mobile/widgets/divider.dart';
import 'package:mobile/widgets/list_tile_for_setting.dart';
import 'package:mobile/widgets/common_dialog.dart';
import 'package:mobile/widgets/bottom_sheet_for_update_photo.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:package_info/package_info.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  SettingScreenState createState() => SettingScreenState();
}

class SettingScreenState extends State<SettingScreen> {
  bool offlineFiles = false;
  bool syncContacts = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {}

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  finish(context);
                },
              ),
              expandedHeight: 120,
              flexibleSpace: FlexibleSpaceBar(title: Text("$appName settings", style: boldTextStyle())),
            ),
          ];
        },
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Your Account", style: boldTextStyle(size: 14)).paddingOnly(top: 10, left: 16),
                    buildDivider(),
                    ListTile(
                      onTap: () {
                        showBottomSheetForUpdatePhoto(context);
                      },
                      visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                      title: Text("Personal", style: boldTextStyle()),
                      subtitle: Text("$appName Basic"),
                      leading: CircleAvatar(backgroundColor: darkBlueColor, child: Text("JD", style: boldTextStyle(size: 16, color: Colors.white))),
                      trailing: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        child: Text("Upgrade", style: boldTextStyle(size: 14, color: Colors.white)),
                        color: darkBlueColor,
                      ).onTap(() {
                        HomeScreen(title: "Upgrade account").launch(context);
                      }),
                    ),
                    buildDivider(),
                    ListTile(
                      title: Text("Edit photo", style: TextStyle(color: darkBlueColor)),
                      onTap: () => showBottomSheetForUpdatePhoto(context),
                      visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                    )
                  ],
                ).paddingOnly(top: 15),
                buildDivider(isFull: true),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Details", style: boldTextStyle(size: 14)).paddingOnly(top: 10, left: 16),
                    buildDivider(),
                    buildListTileForSetting(title: "Email", subTitle: "skg1498@gmail.com"),
                    buildDivider(),
                    buildListTileForSetting(title: "Space used", subTitle: "0.1% of 2.0 GB"),
                    buildDivider(),
                    buildListTileForSetting(
                      title: "Manage devices",
                      subTitle: "1 of 3",
                      onTap: () {
                        HomeScreen(title: "Manage devices").launch(context);
                      },
                    ),
                  ],
                ).paddingOnly(top: 15),
                buildDivider(isFull: true),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Features", style: boldTextStyle(size: 14)).paddingOnly(top: 10, left: 16),
                    buildDivider(),
                    buildListTileForSetting(
                      title: "Camera uploads",
                      trailing: Text("Off", style: TextStyle(fontSize: 16, color: Colors.grey)),
                      onTap: () {
                        HomeScreen(title: "Camera uploads").launch(context);
                      },
                    ),
                    buildDivider(),
                    buildListTileForSetting(
                      title: "Configure passcode",
                      trailing: Text("Off", style: TextStyle(fontSize: 16, color: Colors.grey)),
                      onTap: () {
                        HomeScreen(title: "Configure passcode").launch(context);
                      },
                    ),
                    buildDivider(),
                    buildListTileForSetting(
                      title: "Connect Computer",
                      color: darkBlueColor,
                      onTap: () {
                        HomeScreen(title: "Connect Computer").launch(context);
                      },
                    ),
                    buildDivider(),
                    buildListTileForSetting(title: "Offline Files", subTitle: "Currently using 0 Bytes"),
                    buildDivider(),
                    buildListTileForSetting(
                      title: "Use data for offline files",
                      subTitle: "Offline files will only download when you're connected to Wi-Fi",
                      trailing: Switch(
                        value: offlineFiles,
                        onChanged: (val) async {
                          bool isOK = await (buildCommonDialog(
                            context,
                            title: "Update files on data plan?",
                            content: "Updating files using cellular data could incur data charges",
                          ));
                          offlineFiles = isOK ? true : false;
                          setState(() {});
                        },
                      ),
                    ),
                    buildDivider(),
                    buildListTileForSetting(title: "Dark Mode"),
                  ],
                ).paddingOnly(top: 15),
                buildDivider(isFull: true),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Cloudbox", style: boldTextStyle(size: 14)).paddingOnly(top: 10, left: 16),
                    buildDivider(),
                    buildListTileForSetting(title: "Manage Notification"),
                    buildDivider(),
                    buildListTileForSetting(title: "Manage default apps"),
                    buildDivider(),
                    buildListTileForSetting(
                      title: "Sync contacts",
                      subTitle: "Then you can easily share with your contacts on Cloudbox",
                      trailing: Switch(
                        value: syncContacts,
                        onChanged: (val) {
                          setState(() {
                            syncContacts = val;
                          });
                        },
                      ),
                    ),
                    buildDivider(),
                    buildListTileForSetting(title: "Invite friends to get free space"),
                    buildDivider(),
                    buildListTileForSetting(title: "Get early releases"),
                    buildDivider(),
                    buildListTileForSetting(title: "Help"),
                    buildDivider(),
                    buildListTileForSetting(title: "Send feedback"),
                    buildDivider(),
                    buildListTileForSetting(title: "Terms of service"),
                    buildDivider(),
                    buildListTileForSetting(title: "Privacy policy"),
                    buildDivider(),
                    buildListTileForSetting(title: "Open source & third party software"),
                    buildDivider(),
                    FutureBuilder<PackageInfo>(
                      future: PackageInfo.fromPlatform(),
                      builder: (_, snap) {
                        if (snap.hasError) return Text(snap.error.toString()).center();
                        if (snap.hasData) {
                          return buildListTileForSetting(title: "App version", subTitle: snap.data!.version);
                        }
                        return CircularProgressIndicator();
                      },
                    ),
                  ],
                ).paddingOnly(top: 15),
                buildDivider(isFull: true),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Privacy", style: boldTextStyle(size: 14)).paddingOnly(top: 10, left: 16),
                    buildDivider(),
                    buildListTileForSetting(title: "Hide recent items on Home"),
                    buildDivider(),
                    buildListTileForSetting(
                      title: "Clear cache",
                      onTap: () {
                        toasty(context, "Cache cleared");
                      },
                    ),
                    buildDivider(),
                    buildListTileForSetting(
                      title: "Clear search history",
                      onTap: () {
                        toasty(context, "Recent search history cleared");
                      },
                    ),
                  ],
                ).paddingOnly(top: 15),
                buildDivider(isFull: true),
                buildDivider(isFull: true).paddingTop(10),
                buildListTileForSetting(
                  title: "Sign out of this Cloudbox",
                  color: Colors.red.shade800,
                  onTap: () async {
                    bool isSignOut = await (buildCommonDialog(
                      context,
                      posBtn: "Sign out",
                      content: "Are you sure you want to sign out from your $appName account ?",
                    ));
                    if (isSignOut) {
                      finish(context);
                      HomeScreen(title: "Sign out").launch(context);
                    }
                    setState(() {});
                  },
                ),
                buildDivider(isFull: true),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
