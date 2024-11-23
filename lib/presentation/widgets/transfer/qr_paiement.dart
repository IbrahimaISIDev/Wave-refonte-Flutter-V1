import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wave_app/bloc/transfer/transfer_bloc.dart';
import 'package:wave_app/bloc/transfer/transfer_event.dart';
import 'package:wave_app/bloc/transfer/transfer_state.dart';
import 'package:wave_app/presentation/widgets/transfer/loading_bouton.dart';
import 'package:wave_app/utils/styles.dart';
import 'package:wave_app/services/notification_service.dart';

class QRPaymentForm extends StatefulWidget {
  final String scannedPhone;

  const QRPaymentForm({
    Key? key,
    required this.scannedPhone,
  }) : super(key: key);

  @override
  _QRPaymentFormState createState() => _QRPaymentFormState();
}

class _QRPaymentFormState extends State<QRPaymentForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _amountController;
  bool _isProcessing = false;

  double? get _amount => double.tryParse(_amountController.text.trim());

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _resetForm() {
    _amountController.clear();
    _formKey.currentState?.reset();
  }

  void _submitPayment() {
    if (_formKey.currentState?.validate() ?? false) {
      final amount = _amount;
      if (amount != null) {
        context.read<TransferBloc>().add(
          PerformTransferEvent(
            recipientPhone: widget.scannedPhone,
            amount: amount,
          ),
        );
      }
    }
  }

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
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paiement QR Code'),
        elevation: 0,
      ),
      body: BlocConsumer<TransferBloc, TransferState>(
        listener: (context, state) {
          if (state is TransferSuccess) {
            setState(() => _isProcessing = false);
            NotificationService.showNotification(
              context,
              message: state.message,
              type: NotificationType.success,
            );
            _resetForm();
            Navigator.of(context).pop(); // Retour après succès
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
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Affichage du numéro scanné
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.phone, color: Theme.of(context).primaryColor),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Destinataire',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                widget.scannedPhone,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Champ montant
                  TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    enabled: !_isProcessing,
                    decoration: TransferFormStyles.getInputDecoration(
                      labelText: 'Montant',
                      icon: Icons.attach_money,
                      hintText: '0.00 FCFA', suffixText: '',
                    ),
                    validator: _validateAmount,
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Bouton de paiement
                  LoadingButton(
                    isLoading: _isProcessing,
                    onPressed: _submitPayment,
                    text: 'Confirmer le paiement',
                    style: TransferFormStyles.primaryButtonStyle,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}