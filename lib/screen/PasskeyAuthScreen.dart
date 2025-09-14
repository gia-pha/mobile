
import 'dart:async';
import 'dart:developer';
import 'package:credential_manager/credential_manager.dart';
import 'package:flutter/material.dart';
import 'package:gia_pha_mobile/screen/NBHomeScreen.dart';
import 'package:gia_pha_mobile/services/auth_service.dart';

class PasskeyAuthScreen extends StatefulWidget {
  const PasskeyAuthScreen({super.key});

  @override
  State<PasskeyAuthScreen> createState() => _PasskeyAuthScreenState();
}

class _PasskeyAuthScreenState extends State<PasskeyAuthScreen> {
  bool _loading = true;
  String? errorMessage;


  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      await AuthService.getUser();
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
            ],
          ),
        ),
      ),
    );
  }

  Future<CredentialCreationOptions?> initRegister() async {
    final res = await AuthService.passKeyRegisterInit();
    return res;
  }

  Future<CredentialLoginOptions?> initLogin() async {
    final res = await AuthService.passKeyLoginInit();
    return res;
  }

  Future<void> login() async {
    setState(() {
      errorMessage = null;
    });
    try {
      final options = await initLogin();
      if (options == null) {
        setState(() {
          errorMessage = 'No credentials found';
        });
        return;
      }
      final credResponse =
          await AuthService.credentialManager.getCredentials(
        passKeyOption: CredentialLoginOptions(
          challenge: options.challenge,
          rpId: options.rpId,
          userVerification: options.userVerification,
        ),
      );

      if (credResponse.publicKeyCredential == null) {
        setState(() {
          errorMessage = 'No credentials found';
        });
        return;
      }

      final res = await AuthService.passKeyLoginFinish(
        challenge: options.challenge,
        request: credResponse.publicKeyCredential!,
      );

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const NBHomeScreen()),
      );
      //Navigator.of(context).push(/*waiting dialog */);
      //await Future.delayed(const Duration(seconds: 2));
      if (context.mounted) Navigator.of(context).pop();
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
      final options = await initRegister();
      if (options == null) {
        return;
      }
      final credResponse = await AuthService.credentialManager
          .savePasskeyCredentials(request: options);

      final res = await AuthService.passKeyRegisterFinish(
        challenge: options.challenge,
        request: credResponse,
      );

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const NBHomeScreen()),
      );
    } on CredentialException catch (e) {
      log("Error: ${e.message} ${e.code} ${e.details} ");
      setState(() {
        errorMessage = 'Error: ${e.message}';
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
      });
    }
  }
}
