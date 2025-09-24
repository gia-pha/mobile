import 'package:flutter/material.dart';
import 'package:gia_pha_mobile/screen/PasskeyAuthScreen.dart';
import 'package:gia_pha_mobile/services/relying_party_server.dart';
import 'package:passkeys/authenticator.dart';

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
      home: PasskeyAuthScreen(rps: RelyingPartyServer(), authenticator: PasskeyAuthenticator(),),
    );
  }
}
