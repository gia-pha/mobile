import 'package:flutter/material.dart';
import 'package:gia_pha_mobile/screen/FamilyTreeScreen.dart';
import 'package:gia_pha_mobile/screen/EAForYouTabScreen.dart';
import 'package:gia_pha_mobile/screen/FamilyDetailsScreen.dart';
import 'package:gia_pha_mobile/screen/ImageGalleryScreen.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:gia_pha_mobile/component/NBAllNewsComponent.dart';
import 'package:gia_pha_mobile/component/NBNewsComponent.dart';
import 'package:gia_pha_mobile/model/NBModel.dart';
import 'package:gia_pha_mobile/screen/PurchaseMoreScreen.dart';
import 'package:gia_pha_mobile/screen/EAMayBEYouKnowScreen.dart';
import 'package:gia_pha_mobile/screen/CalendarScreen.dart';
import 'package:gia_pha_mobile/screen/WACategoriesScreen.dart';
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

  List<NBNewsDetailsModel> mNewsList = nbGetNewsDetails();
  List<NBNewsDetailsModel> mTechNewsList = [], mFashionNewsList = [], mSportsNewsList = [], mScienceNewsList = [];

  TabController? tabController;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    tabController = TabController(length: 12, vsync: this);
    for (var element in mNewsList) {
      if (element.categoryName == 'Technology') {
        mTechNewsList.add(element);
      } else if (element.categoryName == 'Fashion') {
        mFashionNewsList.add(element);
      } else if (element.categoryName == 'Sports') {
        mSportsNewsList.add(element);
      } else if (element.categoryName == 'Science') {
        mScienceNewsList.add(element);
      }
    }
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
          tabs: [Tab(text: 'Thông Tin Dòng Họ', icon: Icon(Icons.history)), Tab(text: 'Cây Gia Phả', icon: Icon(Icons.account_tree)), Tab(text: 'Thành Viên', icon: Icon(Icons.people)), Tab(text: 'Sự Kiện', icon: Icon(Icons.event)), Tab(text: 'Lịch', icon: Icon(Icons.calendar_month)), Tab(text: 'Quỹ', icon: Icon(Icons.money)), Tab(text: 'Thư Viện Ảnh', icon: Icon(Icons.image)), Tab(text: 'All News', icon: Icon(Icons.newspaper)), Tab(text: 'Technology', icon: Icon(Icons.devices)), Tab(text: 'Fashion', icon: Icon(Icons.style)), Tab(text: 'Sports', icon: Icon(Icons.sports_score)), Tab(text: 'Science', icon: Icon(Icons.science))],
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
          FamilyDetailsScreen(newsDetails: mNewsList[0],),
          FamilyTreeScreen(),
          EAMayBEYouKnowScreen(),
          EAForYouTabScreen(),
          CalendarScreen(),
          WACategoriesScreen(),
          ImageGalleryScreen(),
          NBAllNewsComponent(),
          PurchaseMoreScreen(false),
          NBNewsComponent(list: mFashionNewsList),
          PurchaseMoreScreen(false),
          NBNewsComponent(list: mScienceNewsList),
        ],
      ),
    );
  }
}
