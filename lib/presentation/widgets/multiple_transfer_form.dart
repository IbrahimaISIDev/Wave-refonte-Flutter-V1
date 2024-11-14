import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wave_app/bloc/transfer/transfer_bloc.dart';
import 'package:wave_app/bloc/transfer/transfer_event.dart';
import 'package:wave_app/utils/styles.dart';

// Formulaire de transferts multiples
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Transferts Multiples',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                maxLines: 3,
                decoration: TransferFormStyles.getInputDecoration(
                  labelText: 'Numéros des bénéficiaires',
                  icon: Icons.group,
                  hintText: 'Séparez les numéros par des virgules',
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Au moins un numéro requis' : null,
                onSaved: (value) => _recipients =
                    value?.split(',').map((e) => e.trim()).toList() ?? [],
              ),
              const SizedBox(height: 20),
              TextFormField(
                keyboardType: TextInputType.phone,
                decoration: TransferFormStyles.getInputDecoration(
                  labelText: 'Montant par personne',
                  icon: Icons.attach_money,
                  hintText: '0.00 FCFA',
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Montant requis' : null,
                onSaved: (value) => _amount = double.parse(value ?? '0'),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: TransferFormStyles.primaryButtonStyle,
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();
                    context.read<TransferBloc>().add(
                          PerformMultipleTransfersEvent(
                            recipientPhones: _recipients,
                            amount: _amount,
                          ),
                        );
                  }
                },
                child: const Text(
                  'Effectuer les transferts',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
