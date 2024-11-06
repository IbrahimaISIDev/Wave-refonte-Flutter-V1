// lib/presentation/widgets/transfer_form.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wave_app/bloc/transfer/transfer_bloc.dart';
import 'package:wave_app/presentation/widgets/custom_text_field.dart';
import 'package:wave_app/bloc/transfer/transfer_state.dart';
import 'package:wave_app/bloc/transfer/transfer_event.dart';

class TransferForm extends StatefulWidget {
  const TransferForm({super.key});

  @override
  State<TransferForm> createState() => _TransferFormState();
}

class _TransferFormState extends State<TransferForm> {
  final _formKey = GlobalKey<FormState>();
  final _recipientController = TextEditingController();
  final _amountController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransferBloc, TransferState>(
      listener: (context, state) {
        if (state is TransferLoading) {
          setState(() => _isLoading = true);
        } else {
          setState(() => _isLoading = false);

          if (state is TransferSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content:
                      Text('Transfert réussi : ${state.transfer.amount} FCFA')),
            );
            _recipientController.clear();
            _amountController.clear();
          } else if (state is TransferError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        }
      },
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                controller: _recipientController,
                label: 'Numéro du bénéficiaire',
                keyboardType: TextInputType.number,
                prefixIcon: Icons.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le numéro du bénéficiaire';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Veuillez entrer un numéro valide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _amountController,
                label: 'Montant',
                keyboardType: TextInputType.number,
                prefixIcon: Icons.attach_money,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un montant';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Veuillez entrer un montant valide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _isLoading ? null : _handleTransfer,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Effectuer le transfert'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleTransfer() {
    if (_formKey.currentState!.validate()) {
      final recipientId = _recipientController.text;
      final amount = double.parse(_amountController.text);

      context.read<TransferBloc>().add(
            CreateTransferEvent(
              recipientId: recipientId,
              amount: amount,
            ),
          );
    }
  }

  @override
  void dispose() {
    _recipientController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}
