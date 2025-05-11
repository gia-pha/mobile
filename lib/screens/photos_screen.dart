import 'package:mobile/widgets/drawer_widget.dart';
import 'package:flutter/material.dart';

class PhotosScreen extends StatefulWidget {
  const PhotosScreen({super.key});

  @override
  PhotosScreenState createState() => PhotosScreenState();
}

class PhotosScreenState extends State<PhotosScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(),
      body: Container(),
    );
  }
}
