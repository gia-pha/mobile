import 'package:flutter/material.dart';
import 'package:gia_pha_mobile/screen/PasskeyAuthScreen.dart';
import 'package:gia_pha_mobile/services/api_service.dart';

class LogoutScreen extends StatefulWidget {
  final ApiService apiService;

  LogoutScreen({super.key, ApiService? apiService})
      : apiService = apiService ?? ApiService();

  @override
  State<LogoutScreen> createState() => _LogoutScreenState();
}

class _LogoutScreenState extends State<LogoutScreen> {
  late final ApiService _apiService = widget.apiService;

  @override
  void initState() {
    super.initState();
    _logout();
  }

  Future<void> _logout() async {
    try {
      final response = await _apiService.post(
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
