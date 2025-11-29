import 'package:gia_pha_mobile/model/NBModel.dart';
import 'package:gia_pha_mobile/screen/NBBookmarkScreen.dart';
import 'package:gia_pha_mobile/screen/NBMembershipScreen.dart';
import 'package:gia_pha_mobile/screen/NBSettingScreen.dart';
import 'package:gia_pha_mobile/screen/PurchaseMoreScreen.dart';
import 'package:gia_pha_mobile/screen/logout_screen.dart';
import 'package:gia_pha_mobile/utils/NBImages.dart';

String details = 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. '
    'Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s,'
    ' when an unknown printer took a galley of type and scrambled it to make a type specimen book. '
    'It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. '
    'It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing '
    'software like Aldus PageMaker including versions of Lorem Ipsum.\n\n'
    'Lorem Ipsum is simply dummy text of the printing and typesetting industry. '
    'Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s,'
    ' when an unknown printer took a galley of type and scrambled it to make a type specimen book. '
    'It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. '
    'It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing '
    'software like Aldus PageMaker including versions of Lorem Ipsum.\n\n'
    'Lorem Ipsum is simply dummy text of the printing and typesetting industry. '
    'Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s,'
    ' when an unknown printer took a galley of type and scrambled it to make a type specimen book. '
    'It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. '
    'It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing '
    'software like Aldus PageMaker including versions of Lorem Ipsum.';

List<NBDrawerItemModel> nbGetDrawerItems() {
  List<NBDrawerItemModel> drawerItems = [];
  drawerItems.add(NBDrawerItemModel(title: 'Home'));
  drawerItems.add(NBDrawerItemModel(title: 'Audio', widget: PurchaseMoreScreen(true)));
  drawerItems.add(NBDrawerItemModel(title: 'Create New Article', widget: PurchaseMoreScreen(true)));
  drawerItems.add(NBDrawerItemModel(title: 'Bookmark', widget: NBBookmarkScreen()));
  drawerItems.add(NBDrawerItemModel(title: 'Membership', widget: NBMembershipScreen()));
  drawerItems.add(NBDrawerItemModel(title: 'Setting', widget: NBSettingScreen()));
  drawerItems.add(NBDrawerItemModel(title: 'Logout', widget: LogoutScreen()));
  return drawerItems;
}

List<NBNewsDetailsModel> nbGetNewsDetails() {
  List<NBNewsDetailsModel> newsDetailsList = [];
  newsDetailsList.add(NBNewsDetailsModel(
    categoryName: 'Sports',
    title: 'NHL roundup: Mika Zibanejad\'s record night powers Rangers',
    date: '20 jan 2021',
    image: NBSportSNews1,
    details: details,
    time: '40:18',
    isBookmark: true,
  ));
  newsDetailsList.add(NBNewsDetailsModel(
    categoryName: 'Technology',
    title: 'Amazfit T-Rex Pro review: This fitness watch is in a league of its own',
    date: '20 jan 2021',
    image: NBTechNews1,
    details: details,
    time: '1:40:18',
  ));
  newsDetailsList.add(NBNewsDetailsModel(
    categoryName: 'Fashion',
    title: 'Amazfit T-Rex Pro review: This fitness watch is in a league of its own',
    date: '20 jan 2021',
    image: NBTechNews1,
    details: details,
    time: '40:00',
    isBookmark: true,
  ));
  newsDetailsList.add(NBNewsDetailsModel(
    categoryName: 'Science',
    title: 'NHL roundup: Mika Zibanejad\'s record night powers Rangers',
    date: '20 jan 2021',
    image: NBSportSNews1,
    details: details,
    time: '15:00',
    isBookmark: true,
  ));
  newsDetailsList.add(NBNewsDetailsModel(
    categoryName: 'Sports',
    title: 'Spring training roundup: Braves get past Rays',
    date: '20 Nov 2020',
    image: NBSportSNews2,
    details: details,
    time: '1:9:30',
  ));
  newsDetailsList.add(NBNewsDetailsModel(
    categoryName: 'Technology',
    title: 'Micromax In 1 review: Clean software gives this budget smartphone an edge',
    date: '20 Nov 2020',
    image: NBTechNews2,
    details: details,
    time: '1:9:30',
    isBookmark: true,
  ));
  newsDetailsList.add(NBNewsDetailsModel(
    categoryName: 'Fashion',
    title: 'Micromax In 1 review: Clean software gives this budget smartphone an edge',
    date: '20 Nov 2020',
    image: NBTechNews2,
    details: details,
    time: '40:00',
  ));
  newsDetailsList.add(NBNewsDetailsModel(
    categoryName: 'Science',
    title: 'Spring training roundup: Braves get past Rays',
    date: '20 Nov 2020',
    image: NBSportSNews2,
    details: details,
    time: '20:00',
  ));
  return newsDetailsList;
}

List<NBSettingsItemModel> nbGetSettingItems() {
  List<NBSettingsItemModel> settingList = [];
  settingList.add(NBSettingsItemModel(title: 'Language', widget: PurchaseMoreScreen(true)));
  settingList.add(NBSettingsItemModel(title: 'Edit Profile', widget: PurchaseMoreScreen(true)));
  settingList.add(NBSettingsItemModel(title: 'Change Password', widget: PurchaseMoreScreen(true)));
  settingList.add(NBSettingsItemModel(title: 'Notification Setting', widget: PurchaseMoreScreen(true)));
  settingList.add(NBSettingsItemModel(title: 'Help and Support'));
  settingList.add(NBSettingsItemModel(title: 'Terms and Conditions'));
  return settingList;
}

List<NBMembershipPlanItemModel> nbGetMembershipPlanItems() {
  List<NBMembershipPlanItemModel> planList = [];
  planList.add(NBMembershipPlanItemModel('Monthly', '\$9.99', 'Billed every month'));
  planList.add(NBMembershipPlanItemModel('Yearly', '\$4.99/month', 'Billed every month'));
  return planList;
}
