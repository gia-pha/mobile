import 'package:flutter/material.dart';
import 'package:gia_pha_mobile/screen/family_tree_screen.dart';
import 'package:gia_pha_mobile/screen/events_screen.dart';
import 'package:gia_pha_mobile/screen/family_intro_screen.dart';
import 'package:gia_pha_mobile/screen/funds_screen.dart';
import 'package:gia_pha_mobile/screen/family_members_screen.dart';
import 'package:gia_pha_mobile/screen/calendar_screen.dart';
import 'package:gia_pha_mobile/screen/user_account_screen.dart';
import 'package:gia_pha_mobile/utils/EAColors.dart';

class NBHomeScreen extends StatefulWidget {
  static String tag = '/NBHomeScreen';

  const NBHomeScreen({super.key});

  @override
  NBHomeScreenState createState() => NBHomeScreenState();
}

class NBHomeScreenState extends State<NBHomeScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TabController? tabController;

  int _selectedIndex = 0;
  final _pages = <Widget>[
    FamilyIntroScreen(),
    FamilyTreeScreen(),
    FamilyMembersScreen(),
    EventsScreen(),
    CalendarScreen(),
    FundsScreen(),
    UserAccountScreen(),
  ];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    tabController = TabController(length: 6, vsync: this);
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
      body: _pages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        clipBehavior: Clip.antiAlias,
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: primaryColor1,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedFontSize: 0,
          unselectedFontSize: 0,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Thông Tin Dòng Họ'),
            BottomNavigationBarItem(icon: Icon(Icons.account_tree), label: 'Cây Gia Phả'),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Thành Viên'),
            BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Sự Kiện'),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Lịch'),
            BottomNavigationBarItem(icon: Icon(Icons.money), label: 'Quỹ'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Tài Khoản'),
          ],
        ),
      ),
    );
  }
}
