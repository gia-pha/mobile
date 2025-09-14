import 'package:flutter/material.dart';
import 'package:gia_pha_mobile/screen/PasskeyAuthScreen.dart';
import 'package:gia_pha_mobile/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (AuthService.credentialManager.isSupportedPlatform) { //check if platform is supported
    await AuthService.credentialManager.init(
      preferImmediatelyAvailableCredentials: true,
    );
  }
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
