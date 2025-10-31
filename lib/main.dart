import 'package:flutter/material.dart';
import 'package:gia_pha_mobile/screen/passkey_auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gia Phả',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PasskeyAuthScreen(),
    );
  }
}
