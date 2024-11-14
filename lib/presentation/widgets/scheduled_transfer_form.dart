import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wave_app/bloc/transfer/transfer_bloc.dart';
import 'package:wave_app/bloc/transfer/transfer_event.dart';
import 'package:wave_app/utils/styles.dart';

class ScheduledTransferForm extends StatefulWidget {
  const ScheduledTransferForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ScheduledTransferFormState createState() => _ScheduledTransferFormState();
}

class _ScheduledTransferFormState extends State<ScheduledTransferForm> {
  final _formKey = GlobalKey<FormState>();
  final _recipientController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Duration? _frequencyDuration;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
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
                'Transfert Programmé',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _recipientController,
                decoration: TransferFormStyles.getInputDecoration(
                  labelText: 'Numéro du bénéficiaire',
                  icon: Icons.person,
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Numéro requis' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: TransferFormStyles.getInputDecoration(
                  labelText: 'Montant',
                  icon: Icons.attach_money,
                  hintText: '0.00 FCFA',
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Montant requis' : null,
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.purple.shade200),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.calendar_today, color: Colors.purple.shade700),
                      const SizedBox(width: 10),
                      Text(
                        _selectedDate == null
                            ? 'Sélectionner une date'
                            : 'Date: ${_selectedDate.toString().split(' ')[0]}',
                        style: TextStyle(
                          color: Colors.purple.shade700,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: TransferFormStyles.getInputDecoration(
                  labelText: 'Fréquence (jours)',
                  icon: Icons.repeat,
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Fréquence requise';
                  if (int.tryParse(value!) == null) return 'Nombre invalide';
                  return null;
                },
                onSaved: (value) {
                  _frequencyDuration = Duration(days: int.parse(value!));
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: TransferFormStyles.primaryButtonStyle,
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();
                    final recipientPhone = _recipientController.text;
                    final amount =
                        double.tryParse(_amountController.text) ?? 0.0;
                    final startDate = _selectedDate;
                    final frequency = _frequencyDuration;

                    if (startDate != null && frequency != null) {
                      // Calculer la date de fin
                      final endDate = startDate.add(frequency);

                      // Envoi de l'événement avec les dates sous forme d'objet DateTime
                      context.read<TransferBloc>().add(
                            ScheduleTransferEvent(
                              recipientPhone: recipientPhone,
                              amount: amount,
                              startDate:
                                  startDate, // Utilisation de DateTime directement
                              endDate:
                                  endDate, // Utilisation de DateTime directement
                              frequency: frequency.inDays
                                  .toString(), // On conserve ici le nombre de jours sous forme de String
                              executionTime: '08:00',
                            ),
                          );
                    }
                  }
                },
                child: const Text(
                  'Programmer le transfert',
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
