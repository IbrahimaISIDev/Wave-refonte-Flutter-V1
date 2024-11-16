// lib/presentation/screens/home/widgets/modals/qr_code_modal.dart
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:wave_app/presentation/screens/home/models/modal_header.dart';
import 'package:wave_app/utils/HomeScreenStyles.dart';

class QRCodeModal extends StatelessWidget {
  final String phoneNumber;

  const QRCodeModal({
    required this.phoneNumber,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      decoration: HomeScreenStyles.modalContainerDecoration,
      child: Column(
        children: [
          const ModalHeader(title: 'Mon QR Code'),
          const SizedBox(height: HomeScreenStyles.largeSpacing),
          QrImageView(
            data: phoneNumber,
            version: QrVersions.auto,
            size: 200.0,
            eyeStyle: QrEyeStyle(
              eyeShape: QrEyeShape.square,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: HomeScreenStyles.largeSpacing),
          Text(
            'Scannez ce code pour m\'envoyer de l\'argent',
            style: HomeScreenStyles.qrCodeInstructionStyle,
          ),
        ],
      ),
    );
  }
}
