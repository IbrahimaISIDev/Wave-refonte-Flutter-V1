import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wave_app/bloc/transfer/transfer_bloc.dart';
import 'package:wave_app/bloc/transfer/transfer_event.dart';

class MultipleTransferForm extends StatefulWidget {
  const MultipleTransferForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MultipleTransferFormState createState() => _MultipleTransferFormState();
}

class _MultipleTransferFormState extends State<MultipleTransferForm> {
  final _formKey = GlobalKey<FormState>();
  late List<String> _recipients;
  late double _amount;

  void _performMultipleTransfer() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      context.read<TransferBloc>().add(
            PerformMultipleTransferEvent(_recipients, _amount),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Numéros de téléphone des bénéficiaires (séparés par des virgules)',
            ),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Veuillez entrer au moins un numéro de téléphone';
              }
              return null;
            },
            onSaved: (value) => _recipients = value?.split(',').map((e) => e.trim()).toList() ?? [],
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Montant à transférer',
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Veuillez entrer un montant';
              }
              return null;
            },
            onSaved: (value) => _amount = double.parse(value ?? '0'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _performMultipleTransfer,
            child: const Text('Transférer'),
          ),
        ],
      ),
    );
  }
}