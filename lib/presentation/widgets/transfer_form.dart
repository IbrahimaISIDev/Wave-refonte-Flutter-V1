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
  bool _isMultipleTransfer = false;
  final List<TextEditingController> _recipientControllers = [];

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
              SnackBar(content: Text('Transfert réussi : ${state.transfer.amount} FCFA')),
            );
            _clearForm();
          } else if (state is TransferError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        }
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Switch pour basculer entre transfert simple et multiple
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Transfert multiple',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Switch(
                  value: _isMultipleTransfer,
                  onChanged: (value) {
                    setState(() {
                      _isMultipleTransfer = value;
                      _clearForm();
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Formulaire
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (!_isMultipleTransfer) 
                    _buildSingleTransferForm()
                  else 
                    _buildMultipleTransferForm(),
                  
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleTransfer,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            _isMultipleTransfer 
                                ? 'Effectuer les transferts' 
                                : 'Effectuer le transfert',
                          ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSingleTransferForm() {
    return Column(
      children: [
        CustomTextField(
          controller: _recipientController,
          label: 'Numéro du bénéficiaire',
          keyboardType: TextInputType.number,
          prefixIcon: Icons.phone,
          validator: _validatePhoneNumber,
        ),
        const SizedBox(height: 20),
        CustomTextField(
          controller: _amountController,
          label: 'Montant',
          keyboardType: TextInputType.number,
          prefixIcon: Icons.attach_money,
          validator: _validateAmount,
        ),
      ],
    );
  }

  Widget _buildMultipleTransferForm() {
    return Column(
      children: [
        // Montant unique pour tous les bénéficiaires
        CustomTextField(
          controller: _amountController,
          label: 'Montant par bénéficiaire',
          keyboardType: TextInputType.number,
          prefixIcon: Icons.attach_money,
          validator: _validateAmount,
        ),
        const SizedBox(height: 20),
        
        // Liste des bénéficiaires
        ..._recipientControllers.asMap().entries.map((entry) {
          final index = entry.key;
          final controller = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: _buildRecipientField(controller, index),
          );
        }),
        
        // Bouton pour ajouter un nouveau bénéficiaire
        OutlinedButton.icon(
          onPressed: _addRecipient,
          icon: const Icon(Icons.person_add),
          label: const Text('Ajouter un bénéficiaire'),
          style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
        ),
        
        if (_recipientControllers.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Ajoutez au moins un bénéficiaire',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
          
        if (_recipientControllers.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Montant total: ${_calculateTotalAmount()} FCFA',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }

  Widget _buildRecipientField(TextEditingController controller, int index) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: CustomTextField(
              controller: controller,
              label: 'Numéro du bénéficiaire ${index + 1}',
              keyboardType: TextInputType.number,
              prefixIcon: Icons.phone,
              validator: _validatePhoneNumber,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
            onPressed: () => _removeRecipient(index),
          ),
        ],
      ),
    );
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer le numéro du bénéficiaire';
    }
    if (value.length < 8 || int.tryParse(value) == null) {
      return 'Numéro de téléphone invalide';
    }
    return null;
  }

  String? _validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer un montant';
    }
    final amount = double.tryParse(value);
    if (amount == null) {
      return 'Montant invalide';
    }
    if (amount <= 0) {
      return 'Le montant doit être supérieur à 0';
    }
    return null;
  }

  String _calculateTotalAmount() {
    final amount = double.tryParse(_amountController.text) ?? 0;
    return (amount * _recipientControllers.length).toStringAsFixed(0);
  }

  void _addRecipient() {
    setState(() {
      _recipientControllers.add(TextEditingController());
    });
  }

  void _removeRecipient(int index) {
    setState(() {
      _recipientControllers[index].dispose();
      _recipientControllers.removeAt(index);
    });
  }

  void _handleTransfer() {
    if (_formKey.currentState!.validate()) {
      final amount = double.parse(_amountController.text);

      if (_isMultipleTransfer) {
        if (_recipientControllers.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ajoutez au moins un bénéficiaire')),
          );
          return;
        }

        // Créer un événement de transfert multiple avec le même montant
        final recipients = _recipientControllers
            .map((controller) => controller.text)
            .toList();

        context.read<TransferBloc>().add(
          CreateMultipleTransferEvent(
            recipients: recipients,
            amount: amount, transfers: [],
          ),
        );
      } else {
        // Transfert simple
        context.read<TransferBloc>().add(
          CreateTransferEvent(
            recipientId: _recipientController.text,
            amount: amount,
          ),
        );
      }
    }
  }

  void _clearForm() {
    _recipientController.clear();
    _amountController.clear();
    for (var controller in _recipientControllers) {
      controller.dispose();
    }
    _recipientControllers.clear();
  }

  @override
  void dispose() {
    _recipientController.dispose();
    _amountController.dispose();
    for (var controller in _recipientControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}