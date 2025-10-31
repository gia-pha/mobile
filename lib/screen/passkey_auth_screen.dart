import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gia_pha_mobile/screen/home_screen.dart';
import 'package:gia_pha_mobile/services/relying_party_server.dart';
import 'package:passkeys/authenticator.dart';

class PasskeyAuthScreen extends StatefulWidget {
  final RelyingPartyServer rps;
  final PasskeyAuthenticator authenticator;

  const PasskeyAuthScreen._({
    required this.rps,
    required this.authenticator,
  });

  factory PasskeyAuthScreen({
    RelyingPartyServer? rps,
    PasskeyAuthenticator? authenticator,
  }) {
    return PasskeyAuthScreen._(
      rps: rps ?? RelyingPartyServer(),
      authenticator: authenticator ?? PasskeyAuthenticator(),
    );
  }

  @override
  State<PasskeyAuthScreen> createState() => _PasskeyAuthScreenState();
}

class _PasskeyAuthScreenState extends State<PasskeyAuthScreen> {
  late final RelyingPartyServer _rps = widget.rps;
  late final PasskeyAuthenticator _authenticator = widget.authenticator;

  bool _loading = true;
  String? errorMessage;


  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      await _rps.getUser();
      _navigateToMain();
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
              Icon(Icons.fingerprint, size: 80),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.login),
                label: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                  child: Text('Sign in with Passkey'),
                ),
                onPressed: login,
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: register,
                child: Text(
                  'Register with Passkey',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (errorMessage != null) // <-- Add this block
                Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> login() async {
    setState(() {
      errorMessage = null;
    });
    try {
      final rps1 = await _rps.passKeyLoginInit();
      final authenticatorRes = await _authenticator.authenticate(rps1);
      _rps.passKeyLoginFinish(data: authenticatorRes);

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const NBHomeScreen()),
      );
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
      });
    }
  }

  Future<void> register() async {
    setState(() {
      errorMessage = null;
    });
    try {
      final rps1 = await _rps.startPasskeyRegister();
      final authenticatorRes = await _authenticator.register(rps1);
      _rps.passKeyRegisterFinish(data: authenticatorRes);

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const NBHomeScreen()),
      );
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
      });
    }
  }
}
