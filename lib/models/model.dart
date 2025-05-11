import 'package:mobile/screens/files_screen.dart';
import 'package:mobile/screens/dashboard_screen.dart';
import 'package:mobile/screens/offline_screen.dart';
import 'package:mobile/screens/photos_screen.dart';
import 'package:mobile/screens/setting_screen.dart';
import 'package:mobile/screens/upgrade_account_screen.dart';
import 'package:flutter/material.dart';

class DrawerModel {
  String? title;
  IconData? icon;
  Widget? goto;
  bool isSelected;

  DrawerModel({this.title, this.icon, this.goto, this.isSelected = false});
}

List<DrawerModel> getCSDrawer() {
  List<DrawerModel> drawerModel = [];
  drawerModel.add(DrawerModel(title: "Home", icon: Icons.home, goto: DashboardScreen()));
  drawerModel.add(DrawerModel(title: "Files", icon: Icons.folder, goto: FilesScreen()));
  drawerModel.add(DrawerModel(title: "Photos", icon: Icons.photo, goto: PhotosScreen()));
  drawerModel.add(DrawerModel(title: "Offline", icon: Icons.offline_bolt, goto: OfflineScreen()));
  drawerModel.add(DrawerModel(title: "Notification", icon: Icons.notifications,goto: SizedBox()));
  drawerModel.add(DrawerModel(title: "Upgrade Account", icon: Icons.upgrade, goto: UpgradeAccountScreen()));
  drawerModel.add(DrawerModel(title: "Setting", icon: Icons.settings, goto: SettingScreen()));

  return drawerModel;
}
