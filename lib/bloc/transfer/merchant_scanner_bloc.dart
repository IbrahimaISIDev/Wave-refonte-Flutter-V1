// lib/bloc/transfer/merchant_scanner_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';

enum MerchantScannerStatus { initial, scanning, success, error }

class MerchantScannerState {
  final String? scannedCode;
  final MerchantScannerStatus status;
  final String? errorMessage;

  MerchantScannerState({
    this.scannedCode,
    this.status = MerchantScannerStatus.initial,
    this.errorMessage,
  });

  MerchantScannerState copyWith({
    String? scannedCode,
    MerchantScannerStatus? status,
    String? errorMessage,
  }) {
    return MerchantScannerState(
      scannedCode: scannedCode ?? this.scannedCode,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

abstract class MerchantScannerEvent {}

class CodeScannedEvent extends MerchantScannerEvent {
  final String code;
  CodeScannedEvent(this.code);
}

class MerchantScannerBloc extends Bloc<MerchantScannerEvent, MerchantScannerState> {
  MerchantScannerBloc() : super(MerchantScannerState()) {
    on<CodeScannedEvent>(_onCodeScanned);
  }

  Future<void> _onCodeScanned(
    CodeScannedEvent event,
    Emitter<MerchantScannerState> emit,
  ) async {
    try {
      emit(state.copyWith(status: MerchantScannerStatus.scanning));
      
      // Ici, vous pouvez ajouter la validation du code QR
      if (event.code.isNotEmpty) {
        emit(state.copyWith(
          status: MerchantScannerStatus.success,
          scannedCode: event.code,
        ));
      } else {
        throw Exception('Code QR invalide');
      }
    } catch (e) {
      emit(state.copyWith(
        status: MerchantScannerStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}