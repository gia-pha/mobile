import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class JoinFamilyScreen extends StatefulWidget {
  const JoinFamilyScreen({super.key});

  @override
  State<JoinFamilyScreen> createState() => _JoinFamilyScreenState();
}

class _JoinFamilyScreenState extends State<JoinFamilyScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  final TextEditingController _familyIdController = TextEditingController();

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Family'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (kIsWeb) {
      return _buildManualInput();
    }
    if (Platform.isAndroid || Platform.isIOS) {
      return _buildQRScanner();
    }
    if (Platform.isLinux) {
      return _buildManualInput();
    }
    return const Center(child: Text('Platform not supported'));
  }

  Widget _buildQRScanner() {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 5,
          child: QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
          ),
        ),
        const Expanded(
          flex: 1,
          child: Center(
            child: Text('Scan a code'),
          ),
        )
      ],
    );
  }

  Widget _buildManualInput() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _familyIdController,
            decoration: const InputDecoration(
              labelText: 'Enter Family ID',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              final familyId = _familyIdController.text;
              if (familyId.isNotEmpty) {
                // TODO: Implement actual join family logic with the entered family ID
                print('Joining family with ID: $familyId');
                Navigator.pop(context);
              }
            },
            child: const Text('Join'),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      controller.pauseCamera();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Family ID: ${scanData.code}'),
          action: SnackBarAction(
            label: 'Join',
            onPressed: () {
              // TODO: Implement actual join family logic with the scanned family ID
              print('Joining family with ID: ${scanData.code}');
              Navigator.pop(context);
            },
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    _familyIdController.dispose();
    super.dispose();
  }
}
