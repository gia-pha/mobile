import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class JoinFamilyScreen extends StatefulWidget {
  const JoinFamilyScreen({super.key});

  @override
  State<JoinFamilyScreen> createState() => _JoinFamilyScreenState();
}

class _JoinFamilyScreenState extends State<JoinFamilyScreen> {
  MobileScannerController controller = MobileScannerController();
  final TextEditingController _familyIdController = TextEditingController();

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
      return _buildQRScanner();
    } else {
      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
        case TargetPlatform.iOS:
          return _buildQRScanner();
        case TargetPlatform.linux:
        case TargetPlatform.windows:
        case TargetPlatform.macOS:
        case TargetPlatform.fuchsia:
          return _buildManualInput();
      }
    }
  }

  Widget _buildQRScanner() {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 5,
          child: MobileScanner(
            controller: controller,
            onDetect: _onDetectBarcode,
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

  void _onDetectBarcode(BarcodeCapture barcodeCapture) {
    if (barcodeCapture.barcodes.isNotEmpty) {
      controller.stop();
      final barcode = barcodeCapture.barcodes.first;
      if (barcode.rawValue != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Family ID: ${barcode.rawValue}'),
            action: SnackBarAction(
              label: 'Join',
              onPressed: () {
                // TODO: Implement actual join family logic with the scanned family ID
                print('Joining family with ID: ${barcode.rawValue}');
                Navigator.pop(context);
              },
            ),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    _familyIdController.dispose();
    super.dispose();
  }
}
