import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gia_pha_mobile/screen/PasskeyAuthScreen.dart';
import 'package:gia_pha_mobile/services/http_client.dart';

class LogoutScreen extends StatefulWidget {
  const LogoutScreen({super.key});

  @override
  State<LogoutScreen> createState() => _LogoutScreenState();
}

class _LogoutScreenState extends State<LogoutScreen> {
  @override
  void initState() {
    super.initState();
    _logout();
  }

  Future<void> _logout() async {
    final Dio dio = HttpClient().dio;
    try {
      final response = await dio.post(
        '/logout',
      );

      if (response.statusCode != 204) {
        debugPrint('Logout failed: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Logout error: $e');
    }
      if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => PasskeyAuthScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Empty screen or loading indicator
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
