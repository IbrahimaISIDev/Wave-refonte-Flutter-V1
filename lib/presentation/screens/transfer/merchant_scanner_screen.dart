// lib/screens/transfer/merchant_scanner_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:wave_app/bloc/transfer/merchant_scanner_bloc.dart';
import 'package:wave_app/presentation/widgets/qr_scanner_button.dart';

class MerchantScannerScreen extends StatefulWidget {
  const MerchantScannerScreen({super.key});

  @override
  State<MerchantScannerScreen> createState() => _MerchantScannerScreenState();
}

class _MerchantScannerScreenState extends State<MerchantScannerScreen> {
  late MobileScannerController _scannerController;

  @override
  void initState() {
    super.initState();
    _scannerController = MobileScannerController(
      facing: CameraFacing.back,
      torchEnabled: false,
    );
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MerchantScannerBloc(),
      child: BlocConsumer<MerchantScannerBloc, MerchantScannerState>(
        listener: (context, state) {
          if (state.status == MerchantScannerStatus.success) {
            Navigator.pop(context, state.scannedCode);
          } else if (state.status == MerchantScannerStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Une erreur est survenue')),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Scanner le QR Code'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.flash_on),
                  onPressed: () => _scannerController.toggleTorch(),
                ),
              ],
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Placez le QR code du marchand dans le cadre',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                        width: 2,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: MobileScanner(
                        controller: _scannerController,
                        onDetect: (capture) {
                          final List barcodes = capture.barcodes;
                          for (final barcode in barcodes) {
                            if (barcode.rawValue != null) {
                              context.read<MerchantScannerBloc>().add(
                                    CodeScannedEvent(barcode.rawValue!),
                                  );
                            }
                          }
                        },
                      ),
                    ),
                  ),
                ),
                QRScannerButton(
                  onCodeScanned: (String code) {
                    print('Code scanné: $code');
                    // Traiter le code QR ici
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}