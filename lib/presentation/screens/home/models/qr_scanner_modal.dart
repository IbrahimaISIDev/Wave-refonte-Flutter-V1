// lib/presentation/screens/home/widgets/modals/qr_scanner_modal.dart
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:wave_app/presentation/screens/home/models/modal_header.dart';
import 'package:wave_app/presentation/widgets/transfer/qr_paiement.dart';
import 'package:wave_app/utils/HomeScreenStyles.dart';

class QRScannerModal extends StatefulWidget {
  const QRScannerModal({super.key});

  @override
  State<QRScannerModal> createState() => _QRScannerModalState();
}

class _QRScannerModalState extends State<QRScannerModal> {
  final MobileScannerController _scannerController = MobileScannerController();

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: HomeScreenStyles.modalContainerDecoration,
      child: Column(
        children: [
          const ModalHeader(title: 'Scanner un QR Code'),
          const SizedBox(height: HomeScreenStyles.largeSpacing),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(20),
              decoration: HomeScreenStyles.scannerContainerDecoration,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: MobileScanner(
                  controller: _scannerController,
                  onDetect: _handleScannedCode,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleScannedCode(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      if (barcode.rawValue != null) {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QRPaymentForm(
              scannedPhone: barcode.rawValue!,
            ),
          ),
        );
        break;
      }
    }
  }
}