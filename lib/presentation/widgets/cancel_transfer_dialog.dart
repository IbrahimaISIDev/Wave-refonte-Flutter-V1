import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wave_app/bloc/transfer/transfer_bloc.dart';
import 'package:wave_app/bloc/transfer/transfer_event.dart';

class CancelTransferDialog extends StatefulWidget {
  final int transactionId;

  const CancelTransferDialog({super.key, required this.transactionId});

  @override
  _CancelTransferDialogState createState() => _CancelTransferDialogState();
}

class _CancelTransferDialogState extends State<CancelTransferDialog> {
  late String _reason;

  void _cancelTransfer() {
    context.read<TransferBloc>().add(
          CancelTransferEvent(widget.transactionId, _reason),
        );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Annuler le transfert'),
      content: TextField(
        decoration: const InputDecoration(
          hintText: 'Raison de l\'annulation',
        ),
        onChanged: (value) => _reason = value,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: _cancelTransfer,
          child: const Text('Confirmer'),
        ),
      ],
    );
  }
}