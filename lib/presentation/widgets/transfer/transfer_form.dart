import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:wave_app/bloc/transfer/transfer_bloc.dart';
import 'package:wave_app/bloc/transfer/transfer_event.dart';
import 'package:wave_app/bloc/transfer/transfer_state.dart';
import 'package:wave_app/presentation/widgets/transfer/loading_bouton.dart';
import 'package:wave_app/utils/contact_selector.dart';
import 'package:wave_app/utils/styles.dart';
import 'package:wave_app/services/notification_service.dart';

class TransferForm extends StatefulWidget {
  final String? recipientId;

  const TransferForm({
    super.key, 
    this.recipientId,
  });

  @override
  _TransferFormState createState() => _TransferFormState();
}

class _TransferFormState extends State<TransferForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _phoneController;
  late TextEditingController _amountController;
  bool _isProcessing = false;

  // Getters pour les valeurs du formulaire
  String get _recipientPhone => _phoneController.text.trim();
  double? get _amount => double.tryParse(_amountController.text.trim());

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController();
    _amountController = TextEditingController();

    // Si un recipientId est fourni, le pré-remplir
    if (widget.recipientId != null) {
      _phoneController.text = widget.recipientId!;
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  // Méthode pour réinitialiser le formulaire
  void _resetForm() {
    _phoneController.clear();
    _amountController.clear();
    _formKey.currentState?.reset();
  }

  // Méthode pour gérer la sélection d'un contact
  Future<void> _selectContact() async {
    try {
      final contact = await showDialog<Contact>(
        context: context,
        builder: (context) => ContactSelector(
          onContactsSelected: (selectedContacts) {
            if (selectedContacts.isNotEmpty) {
              Navigator.of(context).pop(selectedContacts.first);
            }
          },
          onSelectedContacts: null,
        ),
      );

      if (contact?.phones.isNotEmpty ?? false) {
        // Formater le numéro de téléphone si nécessaire
        String phoneNumber = contact!.phones.first.number
            .replaceAll(RegExp(r'[\s-]'), ''); // Supprime les espaces et tirets
        
        setState(() {
          _phoneController.text = phoneNumber;
        });
      }
    } catch (e) {
      NotificationService.showNotification(
        context,
        message: "Erreur lors de l'accès aux contacts: ${e.toString()}",
        type: NotificationType.error,
      );
    }
  }

  // Validation du formulaire et soumission
  void _submitForm() {
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
  }

  // Méthode de validation du numéro de téléphone
  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le numéro de téléphone est requis';
    }
    // Ajoutez ici votre logique de validation de numéro de téléphone
    if (value.length < 8 || value.length > 15) {
      return 'Numéro de téléphone invalide';
    }
    return null;
  }

  // Méthode de validation du montant
  String? _validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le montant est requis';
    }
    final amount = double.tryParse(value);
    if (amount == null) {
      return 'Montant invalide';
    }
    if (amount <= 0) {
      return 'Le montant doit être supérieur à 0';
    }
    // Vous pouvez ajouter d'autres validations ici (montant maximum, etc.)
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransferBloc, TransferState>(
      listener: (context, state) {
        if (state is TransferSuccess) {
          setState(() => _isProcessing = false);
          NotificationService.showNotification(
            context,
            message: state.message,
            type: NotificationType.success,
          );
          _resetForm(); // Réinitialiser le formulaire après un succès
        } else if (state is TransferFailure) {
          setState(() => _isProcessing = false);
          NotificationService.showNotification(
            context,
            message: state.error,
            type: NotificationType.error,
          );
        } else if (state is TransferLoading) {
          setState(() => _isProcessing = true);
        }
      },
      builder: (context, state) {
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
                  
                  // Champ numéro de téléphone avec sélecteur de contact
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          enabled: !_isProcessing,
                          decoration: TransferFormStyles.getInputDecoration(
                            labelText: 'Numéro de téléphone',
                            icon: Icons.phone,
                            hintText: 'Ex: 77123456',
                          ),
                          validator: _validatePhone,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.purple.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.contact_phone,
                            color: Colors.purple.shade700,
                          ),
                          onPressed: _isProcessing ? null : _selectContact,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Champ montant
                  TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    enabled: !_isProcessing,
                    decoration: TransferFormStyles.getInputDecoration(
                      labelText: 'Montant',
                      icon: Icons.attach_money,
                      hintText: '0.00 FCFA',
                    ),
                    validator: _validateAmount,
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Bouton de soumission avec état de chargement
                  LoadingButton(
                    isLoading: _isProcessing,
                    onPressed: _submitForm,
                    text: 'Transférer',
                    style: TransferFormStyles.primaryButtonStyle,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}