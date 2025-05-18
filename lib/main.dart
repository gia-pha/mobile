import 'package:flutter/material.dart';
import 'package:gia_pha_mobile/screen/NBSplashScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dòng họ hiện tại',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NBSplashScreen(),
    );
  }
}
