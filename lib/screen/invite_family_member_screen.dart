import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class InviteFamilyMemberScreen extends StatelessWidget {
  const InviteFamilyMemberScreen({super.key});

  @override
  Widget build(BuildContext context) {
        // TODO: Replace with the actual family ID
        const familyId = 'your-family-id';
    
        return Scaffold(
          appBar: AppBar(
            title: const Text('QR Code to Join'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                QrImageView(
                  data: familyId,
                  version: QrVersions.auto,
                  size: 200.0,
                ),
                const SizedBox(height: 20),
                const Text('Scan this QR code to join our family'),
              ],
            ),
          ),
        );
  }
}