
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gia_pha_mobile/screen/NBHomeScreen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

class PasskeyAuthScreen extends StatefulWidget {
  const PasskeyAuthScreen({super.key});

  @override
  State<PasskeyAuthScreen> createState() => _PasskeyAuthScreenState();
}

class _PasskeyAuthScreenState extends State<PasskeyAuthScreen> {
  static const MethodChannel _channel = MethodChannel('com.example.passkey/channel');

  bool _loading = true;
  String? _statusMessage;
  bool _registered = false;
  List<Map<String, dynamic>> _credentials = [];

  final String backendBase = 'https://your-backend.example.com';

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      final uri = Uri.parse('$backendBase/session');
      final resp = await http.get(uri);
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        if (data['authenticated'] == true) {
          _navigateToMain();
          return;
        }
      }
    } catch (_) {}
    setState(() {
      _loading = false;
    });
  }

  void _navigateToMain() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const NBHomeScreen()),
    );
  }

  Future<void> _signInOrRegister() async {
    setState(() { _loading = true; _statusMessage = null; });
    try {
      final loginOptions = await _fetchLoginOptions();
      if (loginOptions != null) {
        final assertion = await _performNativeAssertion(loginOptions);
        if (assertion != null && await _finishLogin(assertion)) {
          await _loadCredentials();
          setState(() { _statusMessage = 'Signed in successfully'; _registered = true; });
          _navigateToMain();
          return;
        }
      }
      final regOptions = await _fetchRegistrationOptions();
      if (regOptions == null) throw Exception('Failed to fetch registration options');
      final attestation = await _performNativeRegistration(regOptions);
      if (attestation == null) throw Exception('Native registration failed or cancelled');
      if (await _finishRegistration(attestation)) {
        await _loadCredentials();
        setState(() { _statusMessage = 'Registered & signed in successfully'; _registered = true; });
        _navigateToMain();
      } else {
        throw Exception('Server rejected registration');
      }
    } catch (e) {
      setState(() { _statusMessage = 'Error: $e'; });
    } finally {
      setState(() { _loading = false; });
    }
  }

  Future<void> _loadCredentials() async {
    try {
      final uri = Uri.parse('$backendBase/webauthn/credentials');
      final resp = await http.get(uri);
      if (resp.statusCode == 200) {
        final list = jsonDecode(resp.body) as List;
        setState(() { _credentials = list.map((e) => Map<String, dynamic>.from(e)).toList(); });
      }
    } catch (_) {}
  }

  Future<void> _deleteCredential(String id) async {
    try {
      final uri = Uri.parse('$backendBase/webauthn/credentials/$id');
      final resp = await http.delete(uri);
      if (resp.statusCode == 200) {
        _credentials.removeWhere((c) => c['id'] == id);
        setState(() {});
      }
    } catch (_) {}
  }

  Future<Map<String, dynamic>?> _fetchLoginOptions() async {
    try {
      final uri = Uri.parse('$backendBase/webauthn/login/options');
      final resp = await http.post(uri, headers: { 'Content-Type': 'application/json' }, body: jsonEncode({}));
      if (resp.statusCode == 200) return jsonDecode(resp.body);
      return null;
    } catch (_) { return null; }
  }

  Future<bool> _finishLogin(Map<String, dynamic> assertion) async {
    try {
      final uri = Uri.parse('$backendBase/webauthn/login/finish');
      final resp = await http.post(uri, headers: { 'Content-Type': 'application/json' }, body: jsonEncode(assertion));
      return resp.statusCode == 200;
    } catch (_) { return false; }
  }

  Future<Map<String, dynamic>?> _fetchRegistrationOptions() async {
    try {
      final uri = Uri.parse('$backendBase/webauthn/register/options');
      final resp = await http.post(uri, headers: { 'Content-Type': 'application/json' }, body: jsonEncode({}));
      if (resp.statusCode == 200) return jsonDecode(resp.body);
      return null;
    } catch (_) { return null; }
  }

  Future<bool> _finishRegistration(Map<String, dynamic> attestation) async {
    try {
      final uri = Uri.parse('$backendBase/webauthn/register/finish');
      final resp = await http.post(uri, headers: { 'Content-Type': 'application/json' }, body: jsonEncode(attestation));
      return resp.statusCode == 200;
    } catch (_) { return false; }
  }

  Future<Map<String, dynamic>?> _performNativeAssertion(Map<String, dynamic> options) async {
    try {
      final result = await _channel.invokeMethod('passkeyStartLogin', options);
      if (result == null) return null;
      return Map<String, dynamic>.from(result);
    } on PlatformException { return null; }
  }

  Future<Map<String, dynamic>?> _performNativeRegistration(Map<String, dynamic> options) async {
    try {
      final result = await _channel.invokeMethod('passkeyStartRegistration', options);
      if (result == null) return null;
      return Map<String, dynamic>.from(result);
    } on PlatformException { return null; }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('Passkey Authentication')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(_registered ? Icons.verified_user : Icons.fingerprint, size: 80),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.login),
                label: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                  child: Text(_registered ? 'Sign in with Passkey' : 'Register with Passkey'),
                ),
                onPressed: _signInOrRegister,
              ),
              const SizedBox(height: 20),
              if (_credentials.isNotEmpty) ...[
                const Text('Your Passkeys:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: _credentials.length,
                    itemBuilder: (ctx, i) {
                      final cred = _credentials[i];
                      return ListTile(
                        leading: const Icon(Icons.vpn_key),
                        title: Text(cred['name'] ?? cred['id']),
                        subtitle: Text('ID: ${cred['id']}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteCredential(cred['id']),
                        ),
                      );
                    },
                  ),
                ),
              ],
              if (_statusMessage != null) Padding(padding: const EdgeInsets.all(8.0), child: Text(_statusMessage!)),
            ],
          ),
        ),
      ),
    );
  }
}
