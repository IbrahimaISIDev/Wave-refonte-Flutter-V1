import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:provider/provider.dart';
import 'package:wave_app/bloc/transfer/transfer_bloc.dart';
import 'package:wave_app/bloc/transfer/transfer_event.dart';
import 'package:wave_app/utils/contact_selector.dart';
import 'package:wave_app/utils/styles.dart';

class TransferForm extends StatefulWidget {
  const TransferForm({super.key, String? recipientId});

  @override
  _TransferFormState createState() => _TransferFormState();
}

class _TransferFormState extends State<TransferForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _phoneController;
  late TextEditingController _amountController;

  // Fixed getters to return actual values
  String get _recipientPhone => _phoneController.text.trim();
  double? get _amount => double.tryParse(_amountController.text.trim());

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController();
    _amountController = TextEditingController();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _amountController.dispose();
    super.dispose();
  }

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
                'Transfert Simple',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _phoneController,
                      decoration: TransferFormStyles.getInputDecoration(
                        labelText: 'Numéro de téléphone',
                        icon: Icons.phone,
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Numéro requis';
                        }
                        // Add phone number format validation if needed
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.purple.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.contact_phone,
                          color: Colors.purple.shade700),
                      onPressed: () async {
                        final contact = await showDialog<Contact>(
                          context: context,
                          builder: (context) => ContactSelector(
                            onContactsSelected: (selectedContacts) {
                              if (selectedContacts.isNotEmpty) {
                                Navigator.of(context)
                                    .pop(selectedContacts.first);
                              }
                            },
                            onSelectedContacts: null,
                          ),
                        );
                        if (contact?.phones.isNotEmpty ?? false) {
                          setState(() {
                            _phoneController.text =
                                contact!.phones.first.number;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: TransferFormStyles.getInputDecoration(
                  labelText: 'Montant',
                  icon: Icons.attach_money,
                  hintText: '0.00 FCFA',
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Montant requis';
                  }
                  if (double.tryParse(value!) == null) {
                    return 'Montant invalide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: TransferFormStyles.primaryButtonStyle,
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    final amount = _amount;
                    if (amount != null) {
                      context.read<TransferBloc>().add(
                            PerformTransferEvent(
                              recipientPhone: _recipientPhone,
                              amount: amount,
                            ),
                          );
                    }
                  }
                },
                child: const Text(
                  'Transférer',
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