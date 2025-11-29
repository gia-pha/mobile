import 'package:flutter/material.dart';
import 'package:gia_pha_mobile/screen/family_tree_screen.dart';
import 'package:gia_pha_mobile/screen/events_screen.dart';
import 'package:gia_pha_mobile/screen/family_intro_screen.dart';
import 'package:gia_pha_mobile/screen/funds_screen.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:gia_pha_mobile/model/NBModel.dart';
import 'package:gia_pha_mobile/screen/PurchaseMoreScreen.dart';
import 'package:gia_pha_mobile/screen/family_members_screen.dart';
import 'package:gia_pha_mobile/screen/calendar_screen.dart';
import 'package:gia_pha_mobile/utils/NBColors.dart';
import 'package:gia_pha_mobile/utils/NBDataProviders.dart';
import 'package:gia_pha_mobile/utils/NBImages.dart';

class NBHomeScreen extends StatefulWidget {
  static String tag = '/NBHomeScreen';

  const NBHomeScreen({super.key});

  @override
  NBHomeScreenState createState() => NBHomeScreenState();
}

class NBHomeScreenState extends State<NBHomeScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<NBDrawerItemModel> mDrawerList = nbGetDrawerItems();

  TabController? tabController;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    tabController = TabController(length: 12, vsync: this);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.menu,color: Colors.grey),
            onPressed: () {
              _scaffoldKey.currentState!.openDrawer();
            }),
        title: Text('Dòng họ hiện tại', style: boldTextStyle(color: black, size: 20)),
        backgroundColor: white,
        centerTitle: true,
        bottom: TabBar(
          controller: tabController,
          tabs: [Tab(text: 'Thông Tin Dòng Họ', icon: Icon(Icons.history)), Tab(text: 'Cây Gia Phả', icon: Icon(Icons.account_tree)), Tab(text: 'Thành Viên', icon: Icon(Icons.people)), Tab(text: 'Sự Kiện', icon: Icon(Icons.event)), Tab(text: 'Lịch', icon: Icon(Icons.calendar_month)), Tab(text: 'Quỹ', icon: Icon(Icons.money))],
          labelStyle: boldTextStyle(),
          labelColor: black,
          unselectedLabelStyle: primaryTextStyle(),
          unselectedLabelColor: grey,
          isScrollable: true,
          indicatorColor: NBPrimaryColor,
          indicatorWeight: 3,
          indicatorSize: TabBarIndicatorSize.tab,
        ),
      ),
      drawer: Drawer(
        elevation: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 130,
              child: DrawerHeader(
                margin: EdgeInsets.all(0),
                child: ListTile(
                  contentPadding: EdgeInsets.only(left: 0),
                  leading: CircleAvatar(backgroundImage: AssetImage(NBProfileImage), radius: 30),
                  title: Text('Robert Fox', style: boldTextStyle()),
                  subtitle: Text('View Profile', style: secondaryTextStyle()),
                  onTap: () {
                    finish(context);
                    PurchaseMoreScreen(true).launch(context);
                  },
                ),
              ),
            ),
            ListView.separated(
              padding: EdgeInsets.all(8),
              separatorBuilder: (_, index) {
                return Divider();
              },
              itemCount: mDrawerList.length,
              itemBuilder: (_, index) {
                return Text('${mDrawerList[index].title}', style: boldTextStyle()).onTap(() {
                  if (index == 0) {
                    finish(context);
                  } else {
                    finish(context);
                    mDrawerList[index].widget.launch(context);
                  }
                }).paddingAll(8);
              },
            ).expand()
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          FamilyIntroScreen(),
          FamilyTreeScreen(),
          FamilyMembersScreen(),
          EventsScreen(),
          CalendarScreen(),
          FundsScreen(),
        ],
      ),
    );
  }
}
