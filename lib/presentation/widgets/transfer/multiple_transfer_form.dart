import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wave_app/bloc/transfer/transfer_bloc.dart';
import 'package:wave_app/bloc/transfer/transfer_event.dart';
import 'package:wave_app/bloc/transfer/transfer_state.dart';
import 'package:wave_app/presentation/widgets/transfer/loading_bouton.dart';
import 'package:wave_app/services/notification_service.dart';
import 'package:wave_app/utils/styles.dart';

class MultipleTransferForm extends StatefulWidget {
  const MultipleTransferForm({super.key});

  @override
  _MultipleTransferFormState createState() => _MultipleTransferFormState();
}

class _MultipleTransferFormState extends State<MultipleTransferForm> {
  final _formKey = GlobalKey<FormState>();
  late List<String> _recipients;
  late double _amount;
  bool _isProcessing = false;

  String? _validateRecipients(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Au moins un numéro requis';
    }
    return null;
  }

  String? _validateAmount(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Montant requis';
    }
    final amount = double.tryParse(value ?? '');
    if (amount == null || amount <= 0) {
      return 'Montant invalide';
    }
    return null;
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      context.read<TransferBloc>().add(
            PerformMultipleTransfersEvent(
              recipientPhones: _recipients,
              amount: _amount,
            ),
          );
    }
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
                    validator: _validateRecipients,
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
                    validator: _validateAmount,
                    onSaved: (value) => _amount = double.parse(value ?? '0'),
                  ),
                  const SizedBox(height: 32),
                  LoadingButton(
                    isLoading: _isProcessing,
                    onPressed: _submitForm,
                    text: 'Effectuer les transferts',
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