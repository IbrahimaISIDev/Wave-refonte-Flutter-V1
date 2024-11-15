// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:wave_app/bloc/transfer/transfer_bloc.dart';
// import 'package:wave_app/bloc/transfer/transfer_event.dart';
// import 'package:wave_app/bloc/transfer/transfer_state.dart';
// import 'package:wave_app/presentation/widgets/transfer/loading_bouton.dart';
// import 'package:wave_app/services/notification_service.dart';
// import 'package:wave_app/utils/styles.dart';
// import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

// class ScheduledTransferForm extends StatefulWidget {
//   const ScheduledTransferForm({super.key});

//   @override
//   _ScheduledTransferFormState createState() => _ScheduledTransferFormState();
// }

// class _ScheduledTransferFormState extends State<ScheduledTransferForm> {
//   final _formKey = GlobalKey<FormState>();
//   final _recipientController = TextEditingController();
//   final _amountController = TextEditingController();
//   DateTime? _selectedDate;
//   String? _selectedFrequency;
//   TimeOfDay? _selectedTime;
//   bool _isProcessing = false;

//   String? _validateRecipient(String? value) {
//     if (value?.isEmpty ?? true) {
//       return 'Numéro requis';
//     }
//     return null;
//   }

//   String? _validateAmount(String? value) {
//     if (value?.isEmpty ?? true) {
//       return 'Montant requis';
//     }
//     final amount = double.tryParse(value ?? '');
//     if (amount == null || amount <= 0) {
//       return 'Montant invalide';
//     }
//     return null;
//   }

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now().add(const Duration(days: 1)),
//       firstDate: DateTime.now().add(const Duration(days: 1)),
//       lastDate: DateTime.now().add(const Duration(days: 365)),
//     );
//     if (picked != null) {
//       setState(() {
//         _selectedDate = picked;
//       });
//     }
//   }

//   void _selectTime(BuildContext context) async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );
//     if (picked != null) {
//       setState(() {
//         _selectedTime = picked;
//       });
//     }
//   }

//   void _submitForm() {
//     if (_formKey.currentState?.validate() ?? false) {
//       final recipientPhone = _recipientController.text;
//       final amount = double.tryParse(_amountController.text) ?? 0.0;
//       final startDate = _selectedDate;
//       final frequency = _selectedFrequency;
//       final executionTime = _selectedTime?.format(context);

//       if (startDate != null && frequency != null && executionTime != null) {
//         final endDate = startDate.add(const Duration(days: 365));
//         context.read<TransferBloc>().add(
//               ScheduleTransferEvent(
//                 recipientPhone: recipientPhone,
//                 amount: amount,
//                 startDate: startDate,
//                 endDate: endDate,
//                 frequency: frequency,
//                 executionTime: executionTime,
//               ),
//             );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<TransferBloc, TransferState>(
//       listener: (context, state) {
//         if (state is TransferSuccess) {
//           setState(() => _isProcessing = false);
//           NotificationService.showNotification(
//             context,
//             message: state.message,
//             type: NotificationType.success,
//           );
//           _recipientController.clear();
//           _amountController.clear();
//           _selectedDate = null;
//           _selectedFrequency = null;
//           _selectedTime = null;
//         } else if (state is TransferFailure) {
//           setState(() => _isProcessing = false);
//           NotificationService.showNotification(
//             context,
//             message: state.error,
//             type: NotificationType.error,
//           );
//         } else if (state is TransferLoading) {
//           setState(() => _isProcessing = true);
//         }
//       },
//       builder: (context, state) {
//         return Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               TextFormField(
//                 controller: _recipientController,
//                 decoration: TransferFormStyles.getInputDecoration(
//                   labelText: 'Numéro du bénéficiaire',
//                   icon: Icons.person,
//                 ),
//                 validator: _validateRecipient,
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _amountController,
//                 keyboardType: TextInputType.number,
//                 decoration: TransferFormStyles.getInputDecoration(
//                   labelText: 'Montant',
//                   icon: Icons.attach_money,
//                   hintText: '0.00 FCFA',
//                 ),
//                 validator: _validateAmount,
//               ),
//               const SizedBox(height: 20),
//               GestureDetector(
//                 onTap: () => _selectDate(context),
//                 child: InputDecorator(
//                   decoration: TransferFormStyles.getInputDecoration(
//                     labelText: 'Date de début',
//                     icon: Icons.calendar_today,
//                   ),
//                   child: Text(_selectedDate?.toString().split(' ')[0] ?? 'Sélectionner une date'),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               DropdownButtonFormField<String>(
//                 value: _selectedFrequency,
//                 decoration: TransferFormStyles.getInputDecoration(
//                   labelText: 'Fréquence',
//                   icon: Icons.repeat,
//                 ),
//                 items: const [
//                   DropdownMenuItem(value: 'daily', child: Text('Quotidien')),
//                   DropdownMenuItem(value: 'weekly', child: Text('Hebdomadaire')),
//                   DropdownMenuItem(value: 'monthly', child: Text('Mensuel')),
//                 ],
//                 onChanged: (value) {
//                   setState(() {
//                     _selectedFrequency = value;
//                   });
//                 },
//                 validator: (value) =>
//                     value?.isEmpty ?? true ? 'Fréquence requise' : null,
//               ),
//               const SizedBox(height: 20),
//               GestureDetector(
//                 onTap: () => _selectTime(context),
//                 child: InputDecorator(
//                   decoration: TransferFormStyles.getInputDecoration(
//                     labelText: 'Heure d\'exécution',
//                     icon: Icons.access_time,
//                   ),
//                   child: Text(_selectedTime?.format(context) ?? 'Sélectionner une heure'),
//                 ),
//               ),
//               const SizedBox(height: 32),
//               LoadingButton(
//                 isLoading: _isProcessing,
//                 onPressed: _submitForm,
//                 text: 'Programmer le transfert',
//                 style: TransferFormStyles.primaryButtonStyle,
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wave_app/bloc/transfer/transfer_bloc.dart';
import 'package:wave_app/bloc/transfer/transfer_event.dart';
import 'package:wave_app/bloc/transfer/transfer_state.dart';
import 'package:wave_app/presentation/widgets/transfer/loading_bouton.dart';
import 'package:wave_app/services/notification_service.dart';
import 'package:wave_app/utils/styles.dart';
import 'package:intl/intl.dart';

class ScheduledTransferForm extends StatefulWidget {
  const ScheduledTransferForm({super.key});

  @override
  _ScheduledTransferFormState createState() => _ScheduledTransferFormState();
}

class _ScheduledTransferFormState extends State<ScheduledTransferForm> {
  final _formKey = GlobalKey<FormState>();
  final _recipientController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedFrequency;
  TimeOfDay? _selectedTime;
  bool _isProcessing = false;

  @override
  void dispose() {
    _recipientController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  String? _validateRecipient(String? value) {
    return (value?.isEmpty ?? true) ? 'Numéro requis' : null;
  }

  String? _validateAmount(String? value) {
    if (value?.isEmpty ?? true) return 'Montant requis';
    final amount = double.tryParse(value ?? '');
    if (amount == null || amount <= 0) return 'Montant invalide';
    if (amount < 500) return 'Le montant minimum est de 500 FCFA';
    return null;
  }

  String? _validateTime(TimeOfDay? time) {
    if (time == null) return 'Heure d\'exécution requise';
    return null;
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  // Fonction pour formater l'heure au format HH:mm
  String formatTimeOfDay(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    final dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );
    return DateFormat('HH:mm').format(dateTime);
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final recipientPhone = _recipientController.text;
      final amount = double.tryParse(_amountController.text) ?? 0.0;
      final startDate = _selectedDate;
      final frequency = _selectedFrequency;
      final timeValidation = _validateTime(_selectedTime);

      if (timeValidation != null) {
        NotificationService.showNotification(
          context,
          message: timeValidation,
          type: NotificationType.error,
        );
        return;
      }

      if (startDate != null && frequency != null && _selectedTime != null) {
        final endDate = startDate.add(const Duration(days: 365));
        // Formatage de l'heure au format HH:mm
        final formattedTime = formatTimeOfDay(_selectedTime!);

        context.read<TransferBloc>().add(
              ScheduleTransferEvent(
                recipientPhone: recipientPhone,
                amount: amount,
                startDate: startDate,
                endDate: endDate,
                frequency: frequency,
                executionTime: formattedTime, // Utilisation de l'heure formatée
              ),
            );
      }
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
          _formKey.currentState?.reset();
          _recipientController.clear();
          _amountController.clear();
          setState(() {
            _selectedDate = null;
            _selectedFrequency = null;
            _selectedTime = null;
          });
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
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _recipientController,
                decoration: TransferFormStyles.getInputDecoration(
                  labelText: 'Numéro du bénéficiaire',
                  icon: Icons.person,
                ),
                validator: _validateRecipient,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: TransferFormStyles.getInputDecoration(
                  labelText: 'Montant',
                  icon: Icons.attach_money,
                  hintText: '500 FCFA minimum',
                ),
                validator: _validateAmount,
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: FormField<DateTime>(
                  validator: (value) => value == null ? 'Date requise' : null,
                  initialValue: _selectedDate,
                  builder: (FormFieldState<DateTime> state) {
                    return InputDecorator(
                      decoration: TransferFormStyles.getInputDecoration(
                        labelText: 'Date de début',
                        icon: Icons.calendar_today,
                        errorText: state.errorText,
                      ),
                      child: Text(
                        _selectedDate != null
                            ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                            : 'Sélectionner une date',
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedFrequency,
                decoration: TransferFormStyles.getInputDecoration(
                  labelText: 'Fréquence',
                  icon: Icons.repeat,
                ),
                items: const [
                  DropdownMenuItem(value: 'daily', child: Text('Quotidien')),
                  DropdownMenuItem(value: 'weekly', child: Text('Hebdomadaire')),
                  DropdownMenuItem(value: 'monthly', child: Text('Mensuel')),
                ],
                onChanged: (value) => setState(() => _selectedFrequency = value),
                validator: (value) =>
                    (value?.isEmpty ?? true) ? 'Fréquence requise' : null,
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => _selectTime(context),
                child: FormField<TimeOfDay>(
                  validator: (value) => _validateTime(value),
                  initialValue: _selectedTime,
                  builder: (FormFieldState<TimeOfDay> state) {
                    return InputDecorator(
                      decoration: TransferFormStyles.getInputDecoration(
                        labelText: 'Heure d\'exécution',
                        icon: Icons.access_time,
                        errorText: state.errorText,
                      ),
                      child: Text(
                        _selectedTime != null 
                            ? formatTimeOfDay(_selectedTime!)
                            : 'Sélectionner une heure',
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),
              LoadingButton(
                isLoading: _isProcessing,
                onPressed: _submitForm,
                text: 'Programmer le transfert',
                style: TransferFormStyles.primaryButtonStyle,
              ),
            ],
          ),
        );
      },
    );
  }
}